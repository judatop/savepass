import 'package:equatable/equatable.dart';

abstract class AuthInitEvent extends Equatable {
  const AuthInitEvent();

  @override
  List<Object> get props => [];
}

class AuthInitInitialEvent extends AuthInitEvent {
  const AuthInitInitialEvent() : super();
}

class CheckSupabaseBiometricsEvent extends AuthInitEvent{
  const CheckSupabaseBiometricsEvent() : super();
}

class PasswordChangedEvent extends AuthInitEvent {
  final String password;

  const PasswordChangedEvent({required this.password}) : super();
}

class ToggleMasterPasswordEvent extends AuthInitEvent {
  const ToggleMasterPasswordEvent() : super();
}

class SubmitEvent extends AuthInitEvent {
  const SubmitEvent() : super();
}

class SubmitWithBiometricsEvent extends AuthInitEvent{
  const SubmitWithBiometricsEvent() : super();
}

class GetProfileEvent extends AuthInitEvent{
  const GetProfileEvent() : super();
}