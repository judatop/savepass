import 'package:equatable/equatable.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object> get props => [];
}

class SyncInitialEvent extends SyncEvent {
  const SyncInitialEvent() : super();
}

class SyncPasswordChangedEvent extends SyncEvent {
  final String password;

  const SyncPasswordChangedEvent({required this.password}) : super();
}

class SubmitSyncPasswordEvent extends SyncEvent {
  const SubmitSyncPasswordEvent() : super();
}

class ToggleMasterPasswordEvent extends SyncEvent {
  const ToggleMasterPasswordEvent() : super();
}
