import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardInitialEvent extends DashboardEvent {
  const DashboardInitialEvent() : super();
}

class ChangeIndexEvent extends DashboardEvent {
  final int index;

  const ChangeIndexEvent({required this.index}) : super();
}

class ChangeDisplayNameEvent extends DashboardEvent {
  final String displayName;

  const ChangeDisplayNameEvent({required this.displayName}) : super();
}

class ChangeAvatarEvent extends DashboardEvent {
  const ChangeAvatarEvent() : super();
}

class UploadPhotoEvent extends DashboardEvent {
  const UploadPhotoEvent() : super();
}