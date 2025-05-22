import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/infrastructure/models/sign_up_password_form.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/password_form.dart';

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

class InvalidCredentialsState extends AuthState {
  const InvalidCredentialsState(super.model);
}

class UserAlreadyExistsState extends AuthState {
  const UserAlreadyExistsState(super.model);
}

class EmailNotConfirmedState extends AuthState {
  const EmailNotConfirmedState(super.model);
}

class PasswordsMismatch extends AuthState {
  const PasswordsMismatch(super.model);
}

class RecoveryEmailSent extends AuthState {
  const RecoveryEmailSent(super.model);
}

class NewPasswordMustBeDiferentState extends AuthState{
  const NewPasswordMustBeDiferentState(super.model);
}

class NewPasswordSuccessState extends AuthState{
  const NewPasswordSuccessState(super.model);
}

class EmailLinkInvalidExpiredState extends AuthState{
  const EmailLinkInvalidExpiredState(super.model);
}

class UserNeedsConfirmationState extends AuthState{
  const UserNeedsConfirmationState(super.model);
}

class AuthStateModel extends Equatable {
  final AuthType authType;
  final EmailForm email;
  final EmailForm recoveryEmail;
  final bool alreadySubmitted;
  final SignUpPasswordForm signUpPassword;
  final SignUpPasswordForm repeatSignUpPassword;
  final PasswordForm signInPassword;
  final bool showPassword;
  final bool repeatShowPassword;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus forgotPasswordStatus;
  final bool forgotPasswordAlreadySubmitted;
  final bool recoveryPasswordAlreadySubmitted;
  final FormzSubmissionStatus recoveryStatus;
  final SignUpPasswordForm recoveryPassword;
  final SignUpPasswordForm repeatRecoveryPassword;
  final bool showRecoveryPassword;
  final bool showRepeatRecoveryPassword;

  const AuthStateModel({
    this.authType = AuthType.signIn,
    this.email = const EmailForm.pure(),
    this.recoveryEmail = const EmailForm.pure(),
    this.alreadySubmitted = false,
    this.forgotPasswordAlreadySubmitted = false,
    this.signUpPassword = const SignUpPasswordForm.pure(),
    this.repeatSignUpPassword = const SignUpPasswordForm.pure(),
    this.signInPassword = const PasswordForm.pure(),
    this.showPassword = false,
    this.repeatShowPassword = false,
    this.status = FormzSubmissionStatus.initial,
    this.forgotPasswordStatus = FormzSubmissionStatus.initial,
    this.recoveryPasswordAlreadySubmitted = false,
    this.recoveryStatus = FormzSubmissionStatus.initial,
    this.recoveryPassword = const SignUpPasswordForm.pure(),
    this.repeatRecoveryPassword = const SignUpPasswordForm.pure(),
    this.showRecoveryPassword = false,
    this.showRepeatRecoveryPassword = false,
  });

  AuthStateModel copyWith({
    AuthType? authType,
    EmailForm? email,
    EmailForm? recoveryEmail,
    bool? alreadySubmitted,
    bool? forgotPasswordAlreadySubmitted,
    SignUpPasswordForm? signUpPassword,
    SignUpPasswordForm? repeatSignUpPassword,
    PasswordForm? signInPassword,
    bool? showPassword,
    bool? repeatShowPassword,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? forgotPasswordStatus,
    bool? recoveryPasswordAlreadySubmitted,
    FormzSubmissionStatus? recoveryStatus,
    SignUpPasswordForm? recoveryPassword,
    SignUpPasswordForm? repeatRecoveryPassword,
    bool? showRecoveryPassword,
    bool? showRepeatRecoveryPassword,
  }) {
    return AuthStateModel(
      authType: authType ?? this.authType,
      email: email ?? this.email,
      recoveryEmail: recoveryEmail ?? this.recoveryEmail,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      forgotPasswordAlreadySubmitted:
          forgotPasswordAlreadySubmitted ?? this.forgotPasswordAlreadySubmitted,
      signUpPassword: signUpPassword ?? this.signUpPassword,
      repeatSignUpPassword: repeatSignUpPassword ?? this.repeatSignUpPassword,
      signInPassword: signInPassword ?? this.signInPassword,
      showPassword: showPassword ?? this.showPassword,
      repeatShowPassword: repeatShowPassword ?? this.repeatShowPassword,
      status: status ?? this.status,
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      recoveryPasswordAlreadySubmitted: recoveryPasswordAlreadySubmitted ??
          this.recoveryPasswordAlreadySubmitted,
      recoveryStatus: recoveryStatus ?? this.recoveryStatus,
      recoveryPassword: recoveryPassword ?? this.recoveryPassword,
      repeatRecoveryPassword:
          repeatRecoveryPassword ?? this.repeatRecoveryPassword,
      showRecoveryPassword: showRecoveryPassword ?? this.showRecoveryPassword,
      showRepeatRecoveryPassword:
          showRepeatRecoveryPassword ?? this.showRepeatRecoveryPassword,
    );
  }

  @override
  List<Object?> get props => [
        authType,
        email,
        recoveryEmail,
        alreadySubmitted,
        forgotPasswordAlreadySubmitted,
        signUpPassword,
        repeatSignUpPassword,
        signInPassword,
        showPassword,
        repeatShowPassword,
        status,
        forgotPasswordStatus,
        recoveryPasswordAlreadySubmitted,
        recoveryStatus,
        recoveryPassword,
        repeatRecoveryPassword,
        showRecoveryPassword,
        showRepeatRecoveryPassword,
      ];
}
