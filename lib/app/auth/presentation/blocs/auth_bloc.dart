import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/auth/domain/repositories/auth_repository.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/infrastructure/models/sign_up_password_form.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabaseauth;
import 'package:url_launcher/url_launcher.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;
  final PreferencesRepository preferencesRepository;
  final Logger log;

  AuthBloc({
    required this.profileRepository,
    required this.authRepository,
    required this.preferencesRepository,
    required this.log,
  }) : super(const AuthInitialState()) {
    on<AuthInitialEvent>(_onAuthInitialEvent);
    on<AuthEmailInitialEvent>(_onAuthEmailInitialBloc);
    on<OpenSignInEvent>(_onOpenSignInEvent);
    on<OpenSignUpEvent>(_onOpenSignUpEvent);
    on<AuthWithGoogleEvent>(_onAuthWithGoogleEvent);
    on<AuthWithGithubEvent>(_onAuthWithGithubEvent);
    on<AuthWithAppleEvent>(_onAuthWithAppleEvent);
    on<AuthWithEmailEvent>(_onAuthWithEmailEvent);
    on<OpenPrivacyEvent>(_onOpenPrivacyEvent);
    on<OpenTermsEvent>(_onOpenTermsEvent);
    on<ProcessSignedInEvent>(_onProcessSignedInEvent);
    on<EmailChangedEvent>(_onEmailChangedEvent);
    on<PasswordChangedEvent>(_onPasswordChangedEvent);
    on<RepeatPasswordChangedEvent>(_onRepeatPasswordChangedEvent);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<ToggleRepeatPasswordEvent>(_onToggleRepeatPasswordEvent);
    on<InitForgotPasswordEvent>(_onInitForgotPasswordEvent);
    on<RecoveryEmailChangeEvent>(_onRecoveryEmailChangeEvent);
    on<ForgotPasswordSubmitEvent>(_onForgotPasswordSubmitEvent);
    on<InitRecoveryPasswordEvent>(_onInitRecoveryPasswordEvent);
    on<RecoveryPasswordSubmitEvent>(_onRecoveryPasswordSubmitEvent);
    on<ChangeRecoveryPasswordEvent>(_onChangeRecoveryPasswordEvent);
    on<ChangeRepeatRecoveryPasswordEvent>(_onChangeRepeatRecoveryPasswordEvent);
    on<ToggleShowRecoveryPasswordEvent>(_onToggleShowRecoveryPasswordEvent);
    on<ToggleShowRepeatRecoveryPasswordEvent>(
      _onToggleShowRepeatRecoveryPasswordEvent,
    );
    on<LinkInvalidExpiredEvent>(_onLinkInvalidExpiredEvent);
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
    supabase.auth.signInWithOAuth(
      supabaseauth.OAuthProvider.google,
      redirectTo: Env.supabaseRedirectUrl,
      authScreenLaunchMode: supabaseauth.LaunchMode.inAppWebView,
    );
  }

  FutureOr<void> _onAuthWithGithubEvent(
    AuthWithGithubEvent event,
    Emitter<AuthState> emit,
  ) async {
    supabase.auth.signInWithOAuth(
      supabaseauth.OAuthProvider.github,
      redirectTo: Env.supabaseRedirectUrl,
      authScreenLaunchMode: supabaseauth.LaunchMode.inAppWebView,
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
        state.model.repeatSignUpPassword,
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

    if (state.model.signUpPassword.value !=
        state.model.repeatSignUpPassword.value) {
      emit(
        PasswordsMismatch(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    final email = state.model.email.value.toLowerCase();
    late final Either<Fail, supabaseauth.AuthResponse> response;
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

    response.fold(
      (l) {
        if (l.failure is String) {
          final code = l.failure;
          if (code == SnackBarErrors.invalidCredentials) {
            emit(
              InvalidCredentialsState(
                state.model.copyWith(
                  status: FormzSubmissionStatus.failure,
                ),
              ),
            );
            return;
          }

          if (code == SnackBarErrors.userAlreadyExists) {
            emit(
              UserAlreadyExistsState(
                state.model.copyWith(
                  status: FormzSubmissionStatus.failure,
                ),
              ),
            );
            return;
          }

          if (code == SnackBarErrors.emailNotConfirmed) {
            emit(
              EmailNotConfirmedState(
                state.model.copyWith(
                  status: FormzSubmissionStatus.failure,
                ),
              ),
            );
            return;
          }

          emit(
            GeneralErrorState(
              state.model.copyWith(
                status: FormzSubmissionStatus.failure,
              ),
            ),
          );
        }
      },
      (r) {
        emit(
          UserNeedsConfirmationState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onOpenPrivacyEvent(
    OpenPrivacyEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoadingState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final response = await preferencesRepository.getPrivacyUrl();

    late String? policyUrl;

    response.fold(
      (l) {
        policyUrl = null;
      },
      (r) {
        policyUrl = r;
      },
    );

    if (policyUrl == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    emit(
      ChangeAuthState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );

    final Uri url = Uri.parse(policyUrl!);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
    }
  }

  FutureOr<void> _onOpenTermsEvent(
    OpenTermsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoadingState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final response = await preferencesRepository.getTermsUrl();

    late String? termsUrl;

    response.fold(
      (l) {
        termsUrl = null;
      },
      (r) {
        termsUrl = r;
      },
    );

    if (termsUrl == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    emit(
      ChangeAuthState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );

    final Uri url = Uri.parse(termsUrl!);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
    }

    emit(
      ChangeAuthState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );
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
        hasMasterPassword = r.data!['result'];
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

  FutureOr<void> _onToggleMasterPasswordEvent(
    ToggleMasterPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          showPassword: !state.model.showPassword,
        ),
      ),
    );
  }

  FutureOr<void> _onRepeatPasswordChangedEvent(
    RepeatPasswordChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          repeatSignUpPassword: SignUpPasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onToggleRepeatPasswordEvent(
    ToggleRepeatPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          repeatShowPassword: !state.model.repeatShowPassword,
        ),
      ),
    );
  }

  FutureOr<void> _onAuthEmailInitialBloc(
    AuthEmailInitialEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          email: const EmailForm.pure(),
          alreadySubmitted: false,
          signUpPassword: const SignUpPasswordForm.pure(),
          repeatSignUpPassword: const SignUpPasswordForm.pure(),
          signInPassword: const PasswordForm.pure(),
          showPassword: false,
          repeatShowPassword: false,
          status: FormzSubmissionStatus.initial,
        ),
      ),
    );
  }

  FutureOr<void> _onInitForgotPasswordEvent(
    InitForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          forgotPasswordAlreadySubmitted: false,
          recoveryEmail: const EmailForm.pure(),
        ),
      ),
    );
  }

  FutureOr<void> _onRecoveryEmailChangeEvent(
    RecoveryEmailChangeEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          recoveryEmail: EmailForm.dirty(event.email),
        ),
      ),
    );
  }

  FutureOr<void> _onForgotPasswordSubmitEvent(
    ForgotPasswordSubmitEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          forgotPasswordStatus: FormzSubmissionStatus.inProgress,
          forgotPasswordAlreadySubmitted: true,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.recoveryEmail,
    ])) {
      emit(
        ChangeAuthState(
          state.model
              .copyWith(forgotPasswordStatus: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    final response = await authRepository.recoveryPassword(
      email: state.model.recoveryEmail.value,
    );

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model
                .copyWith(forgotPasswordStatus: FormzSubmissionStatus.failure),
          ),
        );
        return;
      },
      (r) {
        emit(
          RecoveryEmailSent(
            state.model
                .copyWith(forgotPasswordStatus: FormzSubmissionStatus.success),
          ),
        );
      },
    );
  }

  FutureOr<void> _onInitRecoveryPasswordEvent(
    InitRecoveryPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          recoveryPassword: const SignUpPasswordForm.pure(),
          repeatRecoveryPassword: const SignUpPasswordForm.pure(),
          showRecoveryPassword: false,
          showRepeatRecoveryPassword: false,
          recoveryPasswordAlreadySubmitted: false,
          recoveryStatus: FormzSubmissionStatus.initial,
        ),
      ),
    );
  }

  FutureOr<void> _onRecoveryPasswordSubmitEvent(
    RecoveryPasswordSubmitEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          recoveryStatus: FormzSubmissionStatus.inProgress,
          recoveryPasswordAlreadySubmitted: true,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.recoveryPassword,
      state.model.repeatRecoveryPassword,
    ])) {
      emit(
        ChangeAuthState(
          state.model.copyWith(recoveryStatus: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    if (state.model.recoveryPassword.value !=
        state.model.repeatRecoveryPassword.value) {
      emit(
        PasswordsMismatch(
          state.model.copyWith(recoveryStatus: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    final response = await authRepository.updateNewPassword(
      password: state.model.recoveryPassword.value,
    );

    response.fold(
      (l) {
        if (l.failure is String) {
          final code = l.failure as String;

          if (code == SnackBarErrors.sameNewPassword) {
            emit(
              NewPasswordMustBeDiferentState(
                state.model
                    .copyWith(recoveryStatus: FormzSubmissionStatus.failure),
              ),
            );
            return;
          }
        }

        emit(
          GeneralErrorState(
            state.model.copyWith(recoveryStatus: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        emit(
          NewPasswordSuccessState(
            state.model.copyWith(recoveryStatus: FormzSubmissionStatus.success),
          ),
        );
      },
    );
  }

  FutureOr<void> _onChangeRecoveryPasswordEvent(
    ChangeRecoveryPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          recoveryPassword: SignUpPasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeRepeatRecoveryPasswordEvent(
    ChangeRepeatRecoveryPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          repeatRecoveryPassword: SignUpPasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onToggleShowRecoveryPasswordEvent(
    ToggleShowRecoveryPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          showRecoveryPassword: !state.model.showRecoveryPassword,
        ),
      ),
    );
  }

  FutureOr<void> _onToggleShowRepeatRecoveryPasswordEvent(
    ToggleShowRepeatRecoveryPasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      ChangeAuthState(
        state.model.copyWith(
          showRepeatRecoveryPassword: !state.model.showRepeatRecoveryPassword,
        ),
      ),
    );
  }

  FutureOr<void> _onLinkInvalidExpiredEvent(
    LinkInvalidExpiredEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(
      EmailLinkInvalidExpiredState(state.model),
    );
  }

  FutureOr<void> _onAuthWithAppleEvent(
    AuthWithAppleEvent event,
    Emitter<AuthState> emit,
  ) async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw Exception('Could not find ID Token from generated credential.');
    }
    supabase.auth.signInWithIdToken(
      provider: supabaseauth.OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }
}
