import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInInitialEvent extends SignInEvent {
  const SignInInitialEvent() : super();
}

class OpenSignUpEvent extends SignInEvent {
  const OpenSignUpEvent() : super();
}

class SignInWithGoogleEvent extends SignInEvent {
  const SignInWithGoogleEvent() : super();
}

class SignInWithGithubEvent extends SignInEvent {
  const SignInWithGithubEvent() : super();
}

class EmailChangedEvent extends SignInEvent {
  final String email;

  const EmailChangedEvent({required this.email}) : super();
}

class PasswordChangedEvent extends SignInEvent {
  final String password;

  const PasswordChangedEvent({required this.password}) : super();
}

class ToggleMasterPasswordEvent extends SignInEvent {
  const ToggleMasterPasswordEvent() : super();
}

class SubmitSignInFormEvent extends SignInEvent {
  const SubmitSignInFormEvent() : super();
}