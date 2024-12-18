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

class ToggleMasterPasswordEvent extends AuthEvent {
  const ToggleMasterPasswordEvent() : super();
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

class ProcessSignedInEvent extends AuthEvent {
  const ProcessSignedInEvent() : super();
}
