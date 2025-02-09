import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/search/infrastructure/models/search_model.dart';
import 'package:savepass/core/form/text_form.dart';

abstract class SearchState extends Equatable {
  final SearchStateModel model;

  const SearchState(this.model);

  @override
  List<Object> get props => [model];
}

class SearchInitialState extends SearchState {
  const SearchInitialState() : super(const SearchStateModel());
}

class ChangeSearchState extends SearchState {
  const ChangeSearchState(super.model);
}

class GeneralErrorState extends SearchState {
  const GeneralErrorState(super.model);
}

class LoadingPasswordState extends SearchState {
  const LoadingPasswordState(super.model);
}

class SearchStateModel extends Equatable {
  final TextForm searchForm;
  final List<SearchModel> searchItems;
  final FormzSubmissionStatus status;

  const SearchStateModel({
    this.searchForm = const TextForm.pure(),
    this.searchItems = const [],
    this.status = FormzSubmissionStatus.initial,
  });

  SearchStateModel copyWith({
    TextForm? searchForm,
    List<SearchModel>? searchItems,
    FormzSubmissionStatus? status,
  }) {
    return SearchStateModel(
      searchForm: searchForm ?? this.searchForm,
      searchItems: searchItems ?? this.searchItems,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        searchForm,
        searchItems,
        status,
      ];
}
