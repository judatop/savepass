import 'package:equatable/equatable.dart';

abstract class PassReportEvent extends Equatable {
  const PassReportEvent();

  @override
  List<Object> get props => [];
}

class PassReportInitialEvent extends PassReportEvent {
  const PassReportInitialEvent() : super();
}

class ChangeSearchTxtEvent extends PassReportEvent {
  final String searchText;

  const ChangeSearchTxtEvent({required this.searchText}) : super();
}

class SubmitSearchEvent extends PassReportEvent {
  final String? search;

  const SubmitSearchEvent({this.search}) : super();
}
