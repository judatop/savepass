import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/infrastructure/models/sign_up_password_form.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/form/text_form.dart';

abstract class AuthState extends Equatable {
  final AuthStateModel model;

  const AuthState(this.model);

  @override
  List<Object> get props => [model];
}

class AuthInitialState extends AuthState {
  const AuthInitialState() : super(const AuthStateModel());
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState(super.model);
}

class ChangeAuthState extends AuthState {
  const ChangeAuthState(super.model);
}

class OpenSignInState extends AuthState {
  const OpenSignInState(super.model);
}

class OpenSignUpState extends AuthState {
  const OpenSignUpState(super.model);
}

class OpenPolicyState extends AuthState {
  const OpenPolicyState(super.model);
}

class OpenAuthEmailState extends AuthState {
  const OpenAuthEmailState(super.model);
}

class OpenHomeState extends AuthState {
  const OpenHomeState(super.model);
}

class EmailAlreadyUsedState extends AuthState {
  const EmailAlreadyUsedState(super.model);
}

class GeneralErrorState extends AuthState {
  const GeneralErrorState(super.model);
}

class OpenSyncPassState extends AuthState {
  const OpenSyncPassState(super.model);
}

class OpenAuthScreenState extends AuthState {
  const OpenAuthScreenState(super.model);
}

class AuthStateModel extends Equatable {
  final AuthType authType;
  final TextForm name;
  final EmailForm email;
  final bool alreadySubmitted;
  final SignUpPasswordForm signUpPassword;
  final PasswordForm signInPassword;
  final bool showPassword;
  final FormzSubmissionStatus status;

  const AuthStateModel({
    this.authType = AuthType.signIn,
    this.name = const TextForm.pure(),
    this.email = const EmailForm.pure(),
    this.alreadySubmitted = false,
    this.signUpPassword = const SignUpPasswordForm.pure(),
    this.signInPassword = const PasswordForm.pure(),
    this.showPassword = false,
    this.status = FormzSubmissionStatus.initial,
  });

  AuthStateModel copyWith({
    AuthType? authType,
    TextForm? name,
    EmailForm? email,
    bool? alreadySubmitted,
    SignUpPasswordForm? signUpPassword,
    PasswordForm? signInPassword,
    bool? showPassword,
    FormzSubmissionStatus? status,
  }) {
    return AuthStateModel(
      authType: authType ?? this.authType,
      name: name ?? this.name,
      email: email ?? this.email,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      signUpPassword: signUpPassword ?? this.signUpPassword,
      signInPassword: signInPassword ?? this.signInPassword,
      showPassword: showPassword ?? this.showPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        authType,
        name,
        email,
        alreadySubmitted,
        signUpPassword,
        signInPassword,
        showPassword,
        status,
      ];
}
