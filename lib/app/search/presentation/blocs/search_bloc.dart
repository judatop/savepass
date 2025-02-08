import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/app/search/presentation/blocs/search_state.dart';
import 'package:savepass/core/form/text_form.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Logger log;

  SearchBloc({
    required this.log,
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
  ) {
    log.i('Submit');
  }
}
