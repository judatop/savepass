import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/search/domain/repositories/search_repository.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/app/search/presentation/blocs/search_state.dart';
import 'package:savepass/core/form/text_form.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Logger log;
  final SearchRepository searchRepository;

  SearchBloc({
    required this.log,
    required this.searchRepository,
  }) : super(const SearchInitialState()) {
    on<SearchInitialEvent>(_onSearchInitialEvent);
    on<ChangeSearchTxtEvent>(_onChangeSearchTxtEvent);
    on<SubmitSearchEvent>(_onSubmitSearchEvent);
  }

  FutureOr<void> _onSearchInitialEvent(
    SearchInitialEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(
      const SearchInitialState(),
    );
  }

  FutureOr<void> _onChangeSearchTxtEvent(
    ChangeSearchTxtEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(
      ChangeSearchState(
        state.model.copyWith(
          searchForm: TextForm.dirty(
            event.searchText,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitSearchEvent(
    SubmitSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      ChangeSearchState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final response = await searchRepository.search(event.search);

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
      },
      (r) {
        emit(
          ChangeSearchState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
              searchItems: r,
            ),
          ),
        );
      },
    );
  }
}
