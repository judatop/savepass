import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_state.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRepository signInRepository;
  final ProfileRepository profileRepository;

  SignInBloc({
    required this.signInRepository,
    required this.profileRepository,
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
    //TODO: implement google sign in
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
