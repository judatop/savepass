import 'package:equatable/equatable.dart';

abstract class CardReportEvent extends Equatable {
  const CardReportEvent();

  @override
  List<Object> get props => [];
}

class CardReportInitialEvent extends CardReportEvent {
  const CardReportInitialEvent() : super();
}

class ChangeSearchTxtEvent extends CardReportEvent {
  final String searchText;

  const ChangeSearchTxtEvent({required this.searchText}) : super();
}

class SubmitSearchEvent extends CardReportEvent {
  final String? search;

  const SubmitSearchEvent({this.search}) : super();
}
