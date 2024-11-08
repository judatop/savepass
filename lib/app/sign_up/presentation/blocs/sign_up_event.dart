import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpInitialEvent extends SignUpEvent {
  const SignUpInitialEvent() : super();
}

class NameSignUpChangedEvent extends SignUpEvent {
  final String name;

  const NameSignUpChangedEvent({required this.name}) : super();
}

class OpenSignInEvent extends SignUpEvent {
  const OpenSignInEvent() : super();
}

class OnSubmitFirstStep extends SignUpEvent {
  const OnSubmitFirstStep() : super();
}

class AlreadyHaveAccountEvent extends SignUpEvent {
  const AlreadyHaveAccountEvent() : super();
}

class OpenPrivacyPolicyEvent extends SignUpEvent {
  const OpenPrivacyPolicyEvent() : super();
}

class NameChangedEvent extends SignUpEvent {
  final String name;

  const NameChangedEvent({required this.name}) : super();
}

class EmailChangedEvent extends SignUpEvent {
  final String email;

  const EmailChangedEvent({required this.email}) : super();
}

class PasswordChangedEvent extends SignUpEvent {
  final String password;

  const PasswordChangedEvent({required this.password}) : super();
}

class AvatarChangedEvent extends SignUpEvent {
  final String imagePath;

  const AvatarChangedEvent({required this.imagePath}) : super();
}

class ToggleMasterPasswordEvent extends SignUpEvent {
  const ToggleMasterPasswordEvent() : super();
}

class SubmitSignUpFormEvent extends SignUpEvent {
  const SubmitSignUpFormEvent() : super();
}

class SignUpWithGoogleEvent extends SignUpEvent {
  const SignUpWithGoogleEvent() : super();
}

class SignUpWithGithubEvent extends SignUpEvent {
  const SignUpWithGithubEvent() : super();
}
