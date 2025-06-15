import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/search/infrastructure/models/search_model.dart';
import 'package:savepass/app/search/infrastructure/models/search_type_enum.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/app/search/presentation/blocs/search_state.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/form/text_form.dart';
import 'package:savepass/core/utils/password_utils.dart';
import 'package:savepass/core/utils/security_utils.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Logger log;
  final PasswordRepository passwordRepository;
  final CardRepository cardRepository;

  SearchBloc({
    required this.log,
    required this.passwordRepository,
    required this.cardRepository,
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
    final searchParam = event.search;
    final searchSaved = state.model.searchForm.value;

    final search = searchParam ?? searchSaved;
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

    emit(
      ChangeSearchState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    List<SearchModel> searchList = [];

    final passwordResponse = await passwordRepository.searchPasswords(
      search: search,
    );

    late final SavePassResponseModel? passwordModelResponse;

    passwordResponse.fold(
      (l) {
        passwordModelResponse = null;
      },
      (r) {
        passwordModelResponse = r;
      },
    );

    if (passwordModelResponse == null) {
      emit(
        ChangeSearchState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<PasswordModel> passwords = [];

    final data = passwordModelResponse?.data;

    if (data != null && data['list'] != null) {
      final passwordsList = data['list'] as List;

      passwords.addAll(
        await Future.wait(
          passwordsList.map(
            (e) async {
              PasswordModel model = PasswordModel.fromJson(e);
              model = model.copyWith(
                password: SecurityUtils.decryptPassword(
                  model.password,
                  derivedKey,
                ),
              );

              if (model.id != null &&
                  model.name != null &&
                  model.vaultId != null) {
                searchList.add(
                  SearchModel(
                    id: model.id!,
                    title: model.name!,
                    subtitle: model.password.split('|')[0],
                    type: SearchType.password.name,
                    vaultId: model.vaultId!,
                    imgUrl: model.typeImg,
                  ),
                );
              }

              return model;
            },
          ),
        ),
      );
    }

    emit(
      ChangeSearchState(
        state.model.copyWith(
          passwords: passwords,
        ),
      ),
    );

    final cardResponse = await cardRepository.searchCards(
      search: search,
    );

    late final SavePassResponseModel? cardResponseModel;
    cardResponse.fold(
      (l) {
        cardResponseModel = null;
      },
      (r) {
        cardResponseModel = r;
      },
    );

    if (cardResponseModel == null) {
      emit(
        ChangeSearchState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<CardModel> cards = [];

    final cardData = cardResponseModel?.data;

    if (cardData != null && cardData['list'] != null) {
      final cardsList = cardData['list'] as List;

      cards.addAll(
        await Future.wait(
          cardsList.map(
            (e) async {
              CardModel model = CardModel.fromJson(e);
              model = model.copyWith(
                card: SecurityUtils.decryptPassword(model.card, derivedKey),
              );

              if (model.id != null &&
                  model.type != null &&
                  model.vaultId != null) {
                final values = model.card.split('|');
                final cardNumber = PasswordUtils.formatCard(values[0]);

                searchList.add(
                  SearchModel(
                    id: model.id!,
                    title: model.type!,
                    subtitle: cardNumber,
                    type: SearchType.card.name,
                    vaultId: model.vaultId!,
                    imgUrl: model.imgUrl,
                  ),
                );
              }

              return model;
            },
          ),
        ),
      );
    }

    emit(
      ChangeSearchState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
          searchItems: searchList,
        ),
      ),
    );
  }
}
