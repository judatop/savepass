import 'package:equatable/equatable.dart';

abstract class EnrollEvent extends Equatable {
  const EnrollEvent();

  @override
  List<Object> get props => [];
}

class EnrollInitialEvent extends EnrollEvent {
  const EnrollInitialEvent() : super();
}

class EnrollNewDeviceEvent extends EnrollEvent {
  final String deviceId;

  const EnrollNewDeviceEvent({required this.deviceId}) : super();
}