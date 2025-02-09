import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchInitialEvent extends SearchEvent {
  const SearchInitialEvent() : super();
}

class ChangeSearchTxtEvent extends SearchEvent {
  final String searchText;

  const ChangeSearchTxtEvent({required this.searchText}) : super();
}

class SubmitSearchEvent extends SearchEvent {
  final String? search;

  const SubmitSearchEvent({this.search}) : super();
}
