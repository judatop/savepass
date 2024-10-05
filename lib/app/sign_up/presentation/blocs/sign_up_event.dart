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