import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/card/presentation/blocs/card_report/card_report_event.dart';
import 'package:savepass/app/card/presentation/blocs/card_report/card_report_state.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/form/text_form.dart';
import 'package:savepass/core/utils/password_utils.dart';
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

    late final SavePassResponseModel? savePassResponse;
    response.fold(
      (l) {
        savePassResponse = null;
      },
      (r) {
        savePassResponse = r;
      },
    );

    if (savePassResponse == null) {
      emit(
        ChangeCardReportState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<CardModel> cards = [];

    final data = savePassResponse?.data;

    if (data != null && data['list'] != null) {
      final cardsList = data['list'] as List;

      final decryptedCards =
          await PasswordUtils.getCards(cardsList, derivedKey);

      cards.addAll(decryptedCards);
    }

    emit(
      ChangeCardReportState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
          cards: cards,
        ),
      ),
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

    late final SavePassResponseModel? savePassResponse;
    response.fold(
      (l) {
        savePassResponse = null;
      },
      (r) {
        savePassResponse = r;
      },
    );

    if (savePassResponse == null) {
      emit(
        ChangeCardReportState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<CardModel> cards = [];

    final data = savePassResponse?.data;

    if (data != null && data['list'] != null) {
      final cardsList = data['list'] as List;

      cards.addAll(
        await Future.wait(
          cardsList.map(
            (e) async {
              CardModel model = CardModel.fromJson(e);
              model = model.copyWith(
                card:
                     SecurityUtils.decryptPassword(model.card, derivedKey),
              );
              return model;
            },
          ),
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
  }
}
