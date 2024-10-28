import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/password_form.dart';

abstract class SignInState extends Equatable {
  final SignInStateModel model;

  const SignInState(this.model);

  @override
  List<Object> get props => [model];
}

class SignInInitialState extends SignInState {
  const SignInInitialState() : super(const SignInStateModel());
}

class SignInStateLoadingState extends SignInState {
  const SignInStateLoadingState(super.model);
}

class ChangeSignInState extends SignInState {
  const ChangeSignInState(super.model);
}

class OpenSignUpState extends SignInState {
  const OpenSignUpState(super.model);
}

class OpenHomeState extends SignInState {
  const OpenHomeState(super.model);
}

class InvalidCredentialsState extends SignInState {
  const InvalidCredentialsState(super.model);
}

class OpenAuthScreenState extends SignInState {
  const OpenAuthScreenState(super.model);
}

class OpenSyncMasterPasswordState extends SignInState {
  const OpenSyncMasterPasswordState(super.model);
}

class GeneralErrorState extends SignInState {
  const GeneralErrorState(super.model);
}

class SignInStateModel extends Equatable {
  final EmailForm email;
  final PasswordForm password;
  final bool alreadySubmitted;
  final bool showMasterPassword;
  final FormzSubmissionStatus status;

  const SignInStateModel({
    this.email = const EmailForm.pure(),
    this.password = const PasswordForm.pure(),
    this.alreadySubmitted = false,
    this.showMasterPassword = false,
    this.status = FormzSubmissionStatus.initial,
  });

  SignInStateModel copyWith({
    EmailForm? email,
    PasswordForm? password,
    bool? alreadySubmitted,
    bool? showMasterPassword,
    FormzSubmissionStatus? status,
  }) {
    return SignInStateModel(
      email: email ?? this.email,
      password: password ?? this.password,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      showMasterPassword: showMasterPassword ?? this.showMasterPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        alreadySubmitted,
        showMasterPassword,
        status,
      ];
}
