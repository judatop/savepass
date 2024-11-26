import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/auth/domain/repositories/auth_repository.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/infrastructure/models/sign_up_password_form.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabaseauth;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;
  final Logger log;

  AuthBloc({
    required this.profileRepository,
    required this.authRepository,
    required this.log,
  }) : super(const AuthInitialState()) {
    on<AuthInitialEvent>(_onAuthInitialEvent);
    on<OpenSignInEvent>(_onOpenSignInEvent);
    on<OpenSignUpEvent>(_onOpenSignUpEvent);
    on<AuthWithGoogleEvent>(_onAuthWithGoogleEvent);
    on<AuthWithGithubEvent>(_onAuthWithGithubEvent);
    on<AuthWithEmailEvent>(_onAuthWithEmailEvent);
    on<OpenPrivacyEvent>(_onOpenPrivacyEvent);
    on<OpenTermsEvent>(_onOpenTermsEvent);
    on<ProcessSignedInEvent>(_onProcessSignedInEvent);
    on<EmailChangedEvent>(_onEmailChangedEvent);
    on<PasswordChangedEvent>(_onPasswordChangedEvent);
  }

  FutureOr<void> _onAuthInitialEvent(
    AuthInitialEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthInitialState());
    emit(
      ChangeAuthState(
        state.model.copyWith(
          authType: event.authType,
        ),
      ),
    );
  }

  FutureOr<void> _onOpenSignInEvent(
    OpenSignInEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthLoadingState(state.model));
    emit(OpenSignInState(state.model));
  }

  FutureOr<void> _onOpenSignUpEvent(
    OpenSignUpEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthLoadingState(state.model));
    emit(OpenSignUpState(state.model));
  }

  FutureOr<void> _onAuthWithGoogleEvent(
    AuthWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    try {
      final webClientId = Env.googleWebClientId;
      final iosClientId = Env.googleIosClientId;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: supabaseauth.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;

      if (user == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }
    } catch (error) {
      log.e('onAuthWithGoogleEvent error: $error');
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
    }
  }

  FutureOr<void> _onAuthWithGithubEvent(
    AuthWithGithubEvent event,
    Emitter<AuthState> emit,
  ) async {
    supabase.auth.signInWithOAuth(
      supabaseauth.OAuthProvider.github,
      redirectTo: Env.supabaseRedirectUrl,
      authScreenLaunchMode: supabaseauth.LaunchMode.externalApplication,
    );
  }

  FutureOr<void> _onAuthWithEmailEvent(
    AuthWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final isSignUp = state.model.authType == AuthType.signUp;

    if (isSignUp) {
      if (!Formz.validate([
        state.model.email,
        state.model.signUpPassword,
      ])) {
        emit(
          ChangeAuthState(
            state.model.copyWith(status: FormzSubmissionStatus.initial),
          ),
        );
        return;
      }
    } else {
      if (!Formz.validate([
        state.model.email,
        state.model.signInPassword,
      ])) {
        emit(
          ChangeAuthState(
            state.model.copyWith(status: FormzSubmissionStatus.initial),
          ),
        );
        return;
      }
    }

    final email = state.model.email.value.toLowerCase();
    late final response;
    if (isSignUp) {
      response = await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: state.model.signUpPassword.value,
      );
    } else {
      response = await authRepository.signInWithEmailAndPassword(
        email: email,
        password: state.model.signInPassword.value,
      );
    }

    late supabaseauth.User? user;
    response.fold(
      (l) {
        user = null;
      },
      (r) {
        user = r.user;
      },
    );

    if (user == null || user?.id == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }
  }

  FutureOr<void> _onOpenPrivacyEvent(
    OpenPrivacyEvent event,
    Emitter<AuthState> emit,
  ) {}

  FutureOr<void> _onOpenTermsEvent(
    OpenTermsEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthLoadingState(state.model));
    emit(OpenPolicyState(state.model));
  }

  FutureOr<void> _onProcessSignedInEvent(
    ProcessSignedInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final checkMasterPasswordResponse =
        await profileRepository.checkIfHasMasterPassword();

    late bool? hasMasterPassword;
    checkMasterPasswordResponse.fold(
      (l) {
        hasMasterPassword = null;
      },
      (r) {
        hasMasterPassword = r;
      },
    );

    if (hasMasterPassword == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    if (hasMasterPassword!) {
      emit(
        OpenAuthScreenState(
          state.model.copyWith(status: FormzSubmissionStatus.success),
        ),
      );

      return;
    }

    emit(
      OpenSyncPassState(
        state.model.copyWith(status: FormzSubmissionStatus.success),
      ),
    );
  }

  FutureOr<void> _onEmailChangedEvent(
    EmailChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    final email = EmailForm.dirty(event.email);
    emit(ChangeAuthState(state.model.copyWith(email: email)));
  }

  FutureOr<void> _onPasswordChangedEvent(
    PasswordChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    final authType = state.model.authType;
    final password = event.password;

    if (authType == AuthType.signUp) {
      emit(
        ChangeAuthState(
          state.model.copyWith(
            signUpPassword: SignUpPasswordForm.dirty(password),
          ),
        ),
      );
    } else {
      emit(
        ChangeAuthState(
          state.model.copyWith(
            signInPassword: PasswordForm.dirty(password),
          ),
        ),
      );
    }
  }
}
