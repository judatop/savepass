import 'package:equatable/equatable.dart';

abstract class ExperiencingIssuesEvent extends Equatable {
  const ExperiencingIssuesEvent();

  @override
  List<Object> get props => [];
}

class ExperiencingIssuesInitialEvent extends ExperiencingIssuesEvent {
  const ExperiencingIssuesInitialEvent() : super();
}
