import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/card/presentation/blocs/card_report/card_report_event.dart';
import 'package:savepass/app/card/presentation/blocs/card_report/card_report_state.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/core/form/text_form.dart';
import 'package:savepass/core/utils/security_utils.dart';

class CardReportBloc extends Bloc<CardReportEvent, CardReportState> {
  final Logger log;
  final CardRepository cardRepository;

  CardReportBloc({
    required this.log,
    required this.cardRepository,
  }) : super(const CardReportInitialState()) {
    on<CardReportInitialEvent>(_onCardReportInitialEvent);
    on<ChangeSearchTxtEvent>(_onChangeSearchTxtEvent);
    on<SubmitSearchEvent>(_onSubmitSearchEvent);
  }

  FutureOr<void> _onCardReportInitialEvent(
    CardReportInitialEvent event,
    Emitter<CardReportState> emit,
  ) async {
    emit(
      ChangeCardReportState(
        state.model.copyWith(status: FormzSubmissionStatus.inProgress),
      ),
    );

    final profileBloc = Modular.get<ProfileBloc>();
    final derivedKey = profileBloc.state.model.derivedKey;

    if (derivedKey == null) {
      emit(
        ChangeCardReportState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final response = await cardRepository.getCards();

    response.fold(
      (l) {
        emit(
          ChangeCardReportState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        List<CardModel> cards = [];

        if (r.data != null && r.data!['list'] != null) {
          final cardsList = r.data!['list'] as List;
          cards.addAll(
            cardsList.map(
              (e) {
                CardModel model = CardModel.fromJson(e);
                model = model.copyWith(
                  card: SecurityUtils.decryptPassword(model.card, derivedKey),
                );
                return model;
              },
            ),
          );
        }

        emit(
          ChangeCardReportState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
              cards: cards,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onChangeSearchTxtEvent(
    ChangeSearchTxtEvent event,
    Emitter<CardReportState> emit,
  ) {
    emit(
      ChangeCardReportState(
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
    Emitter<CardReportState> emit,
  ) async {
    final searchParam = event.search;
    final searchSaved = state.model.searchForm.value;

    final search = searchParam ?? searchSaved;

    if (search.isEmpty) {
      return;
    }

    emit(
      ChangeCardReportState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final profileBloc = Modular.get<ProfileBloc>();
    final derivedKey = profileBloc.state.model.derivedKey;

    if (derivedKey == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final response = await cardRepository.searchCards(
      search: search,
    );

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
        List<CardModel> cards = [];

        if (r.data != null && r.data!['list'] != null) {
          final cardsList = r.data!['list'] as List;
          cards.addAll(
            cardsList.map(
              (e) {
                CardModel model = CardModel.fromJson(e);
                model = model.copyWith(
                  card: SecurityUtils.decryptPassword(model.card, derivedKey),
                );
                return model;
              },
            ),
          );
        }
        emit(
          ChangeCardReportState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
              cards: cards,
            ),
          ),
        );
      },
    );
  }
}
