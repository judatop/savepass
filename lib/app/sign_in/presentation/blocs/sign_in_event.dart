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