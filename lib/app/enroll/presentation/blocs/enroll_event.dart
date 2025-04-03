import 'package:equatable/equatable.dart';

abstract class EnrollEvent extends Equatable {
  const EnrollEvent();

  @override
  List<Object> get props => [];
}

class EnrollInitialEvent extends EnrollEvent {
  const EnrollInitialEvent() : super();
}

class SubmitEnrollEvent extends EnrollEvent {
  const SubmitEnrollEvent() : super();
}
