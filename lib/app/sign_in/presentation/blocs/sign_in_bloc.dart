import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/utils/profile_utils.dart';
import 'package:savepass/app/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_state.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRepository signInRepository;
  final ProfileRepository profileRepository;
  final Logger log;

  SignInBloc({
    required this.signInRepository,
    required this.profileRepository,
    required this.log,
  }) : super(const SignInInitialState()) {
    on<SignInInitialEvent>(_onSignInInitial);
    on<OpenSignUpEvent>(_onOpenSignUp);
    on<SignInWithGoogleEvent>(_onSignInWithGoogleEvent);
    on<SignInWithGithubEvent>(_onSignInWithGithubEvent);
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<SubmitSignInFormEvent>(_onSubmitSignInFormEvent);
  }

  FutureOr<void> _onSignInInitial(
    SignInInitialEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(const SignInInitialState());
  }

  FutureOr<void> _onOpenSignUp(
    OpenSignUpEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(OpenSignUpState(state.model));
  }

  FutureOr<void> _onSignInWithGoogleEvent(
    SignInWithGoogleEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(
      ChangeSignInState(
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

      if (accessToken == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }
      if (idToken == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final emailExistResponse =
          await profileRepository.isEmailExists(googleUser.email);

      String? provider;
      emailExistResponse.fold(
        (l) {},
        (r) {
          provider = r;
        },
      );

      if (provider == null) {
        final response = await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
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

        final createProfileResponse = await profileRepository.createProfile(
          userId: user.id,
          displayName: googleUser.displayName,
          avatarUuid: googleUser.photoUrl,
        );

        createProfileResponse.fold(
          (l) {
            emit(
              GeneralErrorState(
                state.model.copyWith(status: FormzSubmissionStatus.failure),
              ),
            );
          },
          (r) {
            emit(
              OpenSyncMasterPasswordState(
                state.model.copyWith(status: FormzSubmissionStatus.success),
              ),
            );
          },
        );

        return;
      }

      if (provider != ProfileUtils.googleProvider) {
        emit(
          EmailAlreadyInUseState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      emit(
        OpenAuthScreenState(
          state.model.copyWith(status: FormzSubmissionStatus.success),
        ),
      );
    } catch (error) {
      log.e('onSignInWithGoogle error: $error');
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
    }
  }

  FutureOr<void> _onSignInWithGithubEvent(
    SignInWithGithubEvent event,
    Emitter<SignInState> emit,
  ) async {
    //TODO: implement github sign in
  }

  FutureOr<void> _onEmailChanged(
    EmailChangedEvent event,
    Emitter<SignInState> emit,
  ) {
    final email = EmailForm.dirty(event.email);
    emit(ChangeSignInState(state.model.copyWith(email: email)));
  }

  FutureOr<void> _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<SignInState> emit,
  ) {
    final password = PasswordForm.dirty(event.password);
    emit(ChangeSignInState(state.model.copyWith(password: password)));
  }

  FutureOr<void> _onToggleMasterPasswordEvent(
    ToggleMasterPasswordEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(
      ChangeSignInState(
        state.model
            .copyWith(showMasterPassword: !state.model.showMasterPassword),
      ),
    );
  }

  FutureOr<void> _onSubmitSignInFormEvent(
    SubmitSignInFormEvent event,
    Emitter<SignInState> emit,
  ) async {
    emit(
      ChangeSignInState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.email,
      state.model.password,
    ])) {
      emit(
        ChangeSignInState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    final email = state.model.email.value.toLowerCase();
    final password = state.model.password.value;
    final response = await signInRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    bool? successSignIn;
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
        successSignIn = true;
      },
    );

    if (successSignIn == null) {
      return;
    }

    final hasMasterPasswordResponse =
        await profileRepository.checkIfHasMasterPassword();

    hasMasterPasswordResponse.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
      },
      (r) {
        if (!r) {
          emit(
            OpenSyncMasterPasswordState(
              state.model.copyWith(
                status: FormzSubmissionStatus.success,
              ),
            ),
          );
          return;
        }

        emit(
          OpenAuthScreenState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
  }
}
