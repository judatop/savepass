import 'package:equatable/equatable.dart';

abstract class MasterPasswordEvent extends Equatable {
  const MasterPasswordEvent();

  @override
  List<Object> get props => [];
}

class MasterPasswordInitialEvent extends MasterPasswordEvent {
  const MasterPasswordInitialEvent() : super();
}

class OldPasswordChangedEvent extends MasterPasswordEvent {
  final String password;

  const OldPasswordChangedEvent({required this.password}) : super();
}

class NewPasswordChangedEvent extends MasterPasswordEvent {
  final String password;

  const NewPasswordChangedEvent({required this.password}) : super();
}

class RepeatPasswordChangedEvent extends MasterPasswordEvent {
  final String password;

  const RepeatPasswordChangedEvent({required this.password}) : super();
}

class SubmitEvent extends MasterPasswordEvent {
  const SubmitEvent() : super();
}

class ToggleOldPasswordEvent extends MasterPasswordEvent {
  const ToggleOldPasswordEvent() : super();
}

class ToggleNewPasswordEvent extends MasterPasswordEvent {
  const ToggleNewPasswordEvent() : super();
}

class ToggleRepeatPasswordEvent extends MasterPasswordEvent {
  const ToggleRepeatPasswordEvent() : super();
}