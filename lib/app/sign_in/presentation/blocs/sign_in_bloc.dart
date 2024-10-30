import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/web.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_state.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/password_form.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInInitialState()) {
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
    try {
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // final GoogleSignInAuthentication? googleAuth =
      //     await googleUser?.authentication;

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );

      // final user = await FirebaseAuth.instance.signInWithCredential(credential);

      //TODO: check if user is synched with master password
      emit(
        OpenAuthScreenState(
          state.model,
        ),
      );
    } catch (e) {
      Logger().e(e.toString());
      emit(
        GeneralErrorState(
          state.model,
        ),
      );
    }
  }

  FutureOr<void> _onSignInWithGithubEvent(
    SignInWithGithubEvent event,
    Emitter<SignInState> emit,
  ) async {
    // try {
    //   GithubAuthProvider githubProvider = GithubAuthProvider();
    //   await FirebaseAuth.instance.signInWithProvider(githubProvider);
    //   emit(
    //     OpenHomeState(
    //       state.model,
    //     ),
    //   );
    // } catch (e) {
    //   Logger().e(e.toString());
    // }
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

    // try {
    //   await FirebaseAuth.instance.signInWithCredential(
    //     EmailAuthProvider.credential(
    //       email: state.model.email.value,
    //       password: state.model.password.value,
    //     ),
    //   );

    //   Future.delayed(const Duration(seconds: 2));

    //   emit(
    //     OpenHomeState(
    //       state.model.copyWith(status: FormzSubmissionStatus.success),
    //     ),
    //   );
    // } catch (e) {
    //   if (e is FirebaseAuthException) {
    //     if (e.code == 'invalid-credential') {
    //       emit(
    //         InvalidCredentialsState(
    //           state.model.copyWith(status: FormzSubmissionStatus.failure),
    //         ),
    //       );
    //     }
    //   }

    //   Logger().e('sign in error: ${e.toString()}');
    // }
  }
}
