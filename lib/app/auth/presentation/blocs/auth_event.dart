import 'package:equatable/equatable.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthInitialEvent extends AuthEvent {
  final AuthType authType;

  const AuthInitialEvent({required this.authType}) : super();
}

class AuthEmailInitialEvent extends AuthEvent {
  const AuthEmailInitialEvent() : super();
}

class OpenSignInEvent extends AuthEvent {
  const OpenSignInEvent() : super();
}

class OpenSignUpEvent extends AuthEvent {
  const OpenSignUpEvent() : super();
}

class OpenPrivacyEvent extends AuthEvent {
  const OpenPrivacyEvent() : super();
}

class OpenTermsEvent extends AuthEvent {
  const OpenTermsEvent() : super();
}

class EmailChangedEvent extends AuthEvent {
  final String email;

  const EmailChangedEvent({required this.email}) : super();
}

class PasswordChangedEvent extends AuthEvent {
  final String password;

  const PasswordChangedEvent({required this.password}) : super();
}

class RepeatPasswordChangedEvent extends AuthEvent {
  final String password;

  const RepeatPasswordChangedEvent({required this.password}) : super();
}

class ToggleMasterPasswordEvent extends AuthEvent {
  const ToggleMasterPasswordEvent() : super();
}

class ToggleRepeatPasswordEvent extends AuthEvent {
  const ToggleRepeatPasswordEvent() : super();
}

class AuthWithEmailEvent extends AuthEvent {
  const AuthWithEmailEvent() : super();
}

class AuthWithGoogleEvent extends AuthEvent {
  const AuthWithGoogleEvent() : super();
}

class AuthWithGithubEvent extends AuthEvent {
  const AuthWithGithubEvent() : super();
}

class AuthWithAppleEvent extends AuthEvent {
  const AuthWithAppleEvent() : super();
}

class ProcessSignedInEvent extends AuthEvent {
  const ProcessSignedInEvent() : super();
}

class InitForgotPasswordEvent extends AuthEvent {
  const InitForgotPasswordEvent() : super();
}

class RecoveryEmailChangeEvent extends AuthEvent {
  final String email;

  const RecoveryEmailChangeEvent({required this.email}) : super();
}

class ForgotPasswordSubmitEvent extends AuthEvent {
  const ForgotPasswordSubmitEvent() : super();
}

class InitRecoveryPasswordEvent extends AuthEvent {
  const InitRecoveryPasswordEvent() : super();
}

class RecoveryPasswordSubmitEvent extends AuthEvent {
  const RecoveryPasswordSubmitEvent() : super();
}

class ChangeRecoveryPasswordEvent extends AuthEvent {
  final String password;

  const ChangeRecoveryPasswordEvent({required this.password}) : super();
}

class ChangeRepeatRecoveryPasswordEvent extends AuthEvent {
  final String password;

  const ChangeRepeatRecoveryPasswordEvent({required this.password}) : super();
}

class ToggleShowRecoveryPasswordEvent extends AuthEvent{
  const ToggleShowRecoveryPasswordEvent() : super();
}

class ToggleShowRepeatRecoveryPasswordEvent extends AuthEvent{
  const ToggleShowRepeatRecoveryPasswordEvent() : super();
}

class LinkInvalidExpiredEvent extends AuthEvent{
  const LinkInvalidExpiredEvent() : super();
}
