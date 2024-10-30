import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/web.dart';
import 'package:savepass/app/sign_up/infrastructure/models/master_password_form.dart';
import 'package:savepass/app/sign_up/infrastructure/models/sign_up_type_enum.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/text_form.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpInitialState()) {
    on<SignUpInitialEvent>(_onSignUpInitial);
    on<NameSignUpChangedEvent>(_onNameSignUpChanged);
    on<OnSubmitFirstStep>(_onOnSubmitFirstStep);
    on<AlreadyHaveAccountEvent>(_onAlreadyHaveAccountEvent);
    on<OpenPrivacyPolicyEvent>(_onOpenPrivacyPolicyEvent);
    on<NameChangedEvent>(_onNameChanged);
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<AvatarChangedEvent>(_onAvatarChanged);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<SubmitSignUpFormEvent>(_onSubmitSignUpFormEvent);
    on<SignUpWithGoogleEvent>(_onSignUpWithGoogleEvent);
    on<SignUpWithGithubEvent>(_onSignUpWithGithubEvent);
    on<SubmitSyncPasswordEvent>(_onSubmitSyncPasswordEvent);
  }

  FutureOr<void> _onNameSignUpChanged(
    NameSignUpChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final name = TextForm.dirty(event.name);
    emit(ChangeSignUpState(state.model.copyWith(name: name)));
  }

  FutureOr<void> _onSignUpInitial(
    SignUpInitialEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(const SignUpInitialState());
  }

  FutureOr<void> _onOnSubmitFirstStep(
    OnSubmitFirstStep event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      ChangeSignUpState(
        state.model.copyWith(
          alreadySubmitted: true,
        ),
      ),
    );

    if (!Formz.validate([state.model.name])) {
      return;
    }

    emit(OpenSignUpWithEmailState(state.model));
  }

  FutureOr<void> _onAlreadyHaveAccountEvent(
    AlreadyHaveAccountEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(SignUpLoadingState(state.model));
    emit(OpenSignInState(state.model));
  }

  FutureOr<void> _onOpenPrivacyPolicyEvent(
    OpenPrivacyPolicyEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(SignUpLoadingState(state.model));
    emit(OpenPrivacyPolicyState(state.model));
  }

  FutureOr<void> _onNameChanged(
    NameChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final name = TextForm.dirty(event.name);
    emit(ChangeSignUpState(state.model.copyWith(name: name)));
  }

  FutureOr<void> _onEmailChanged(
    EmailChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final email = EmailForm.dirty(event.email);
    emit(ChangeSignUpState(state.model.copyWith(email: email)));
  }

  FutureOr<void> _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final password = MasterPasswordForm.dirty(event.password);
    emit(ChangeSignUpState(state.model.copyWith(masterPassword: password)));
  }

  FutureOr<void> _onAvatarChanged(
    AvatarChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final imagePath = event.imagePath;
    emit(ChangeSignUpState(state.model.copyWith(selectedImg: imagePath)));
  }

  FutureOr<void> _onToggleMasterPasswordEvent(
    ToggleMasterPasswordEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      ChangeSignUpState(
        state.model
            .copyWith(showMasterPassword: !state.model.showMasterPassword),
      ),
    );
  }

  FutureOr<void> _onSubmitSignUpFormEvent(
    SubmitSignUpFormEvent event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      ChangeSignUpState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.email,
      state.model.masterPassword,
    ])) {
      emit(
        ChangeSignUpState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    // try {
    //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: state.model.email.value,
    //     password: state.model.masterPassword.value,
    //   );

    //   //TODO: Upload name and image to supabase
    //   Future.delayed(const Duration(seconds: 2));

    //   emit(
    //     OpenHomeState(
    //       state.model.copyWith(status: FormzSubmissionStatus.success),
    //     ),
    //   );
    // } catch (e) {
    //   if (e is FirebaseAuthException) {
    //     if (e.code == 'email-already-in-use') {
    //       emit(
    //         EmailAlreadyInUseState(
    //           state.model.copyWith(status: FormzSubmissionStatus.failure),
    //         ),
    //       );
    //     }
    //   }

    //   Logger().e('sign up error: ${e.toString()}');
    // }
  }

  FutureOr<void> _onSignUpWithGoogleEvent(
    SignUpWithGoogleEvent event,
    Emitter<SignUpState> emit,
  ) async {
    // try {
    //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //   final GoogleSignInAuthentication? googleAuth =
    //       await googleUser?.authentication;

    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth?.accessToken,
    //     idToken: googleAuth?.idToken,
    //   );

    //   final user = await FirebaseAuth.instance.signInWithCredential(credential);

    //   emit(
    //     SyncMasterPasswordState(
    //       state.model.copyWith(
    //         userFirebase: user.user,
    //         signUpType: SignUpTypeEnum.google,
    //       ),
    //     ),
    //   );
    // } catch (e) {
    //   Logger().e(e.toString());
    // }
  }

  FutureOr<void> _onSignUpWithGithubEvent(
    SignUpWithGithubEvent event,
    Emitter<SignUpState> emit,
  ) async {
    // try {
    //   GithubAuthProvider githubProvider = GithubAuthProvider();
    //   final user =
    //       await FirebaseAuth.instance.signInWithProvider(githubProvider);
    //   emit(
    //     SyncMasterPasswordState(
    //       state.model.copyWith(
    //         userFirebase: user.user,
    //         signUpType: SignUpTypeEnum.github,
    //       ),
    //     ),
    //   );
    // } catch (e) {
    //   Logger().e(e.toString());
    // }
  }

  FutureOr<void> _onSubmitSyncPasswordEvent(
    SubmitSyncPasswordEvent event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      ChangeSignUpState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.masterPassword,
    ])) {
      emit(
        ChangeSignUpState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    try {
      //TODO: Sync master password to Supabase
      await Future.delayed(const Duration(seconds: 3));

      emit(
        OpenHomeState(
          state.model.copyWith(status: FormzSubmissionStatus.success),
        ),
      );
    } catch (e) {
      Logger().e('sign up error: ${e.toString()}');
    }
  }
}
