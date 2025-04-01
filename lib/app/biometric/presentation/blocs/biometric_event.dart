import 'package:equatable/equatable.dart';

abstract class BiometricEvent extends Equatable {
  const BiometricEvent();

  @override
  List<Object> get props => [];
}

class BiometricInitialEvent extends BiometricEvent {
  const BiometricInitialEvent() : super();
}

class SubmitBiometricEvent extends BiometricEvent {
  const SubmitBiometricEvent() : super();
}

class BiometricPasswordChangedEvent extends BiometricEvent {
  final String password;

  const BiometricPasswordChangedEvent({required this.password}) : super();
}

class ToggleMasterPasswordEvent extends BiometricEvent {
  const ToggleMasterPasswordEvent() : super();
}