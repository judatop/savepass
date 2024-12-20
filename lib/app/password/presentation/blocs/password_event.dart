import 'package:equatable/equatable.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object> get props => [];
}

class PasswordInitialEvent extends PasswordEvent {
  const PasswordInitialEvent() : super();
}

class ChangeNameEvent extends PasswordEvent {
  final String name;

  const ChangeNameEvent({required this.name}) : super();
}

class ChageEmailEvent extends PasswordEvent {
  final String email;

  const ChageEmailEvent({required this.email}) : super();
}

class ChangePasswordEvent extends PasswordEvent {
  final String password;

  const ChangePasswordEvent({required this.password}) : super();
}

class ChangeTagEvent extends PasswordEvent {
  final String tag;

  const ChangeTagEvent({required this.tag}) : super();
}

class ChangeDescEvent extends PasswordEvent {
  final String desc;

  const ChangeDescEvent({required this.desc}) : super();
}

class TogglePasswordEvent extends PasswordEvent {
  const TogglePasswordEvent() : super();
}
