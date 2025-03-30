import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/app/search/infrastructure/models/search_model.dart';
import 'package:savepass/app/search/infrastructure/models/search_type_enum.dart';
import 'package:savepass/app/search/presentation/blocs/search_event.dart';
import 'package:savepass/app/search/presentation/blocs/search_state.dart';
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

    passwordResponse.fold(
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
        List<PasswordModel> passwords = [];

        if (r.data != null && r.data!['list'] != null) {
          final passwordsList = r.data!['list'] as List;

          final result = passwordsList.map(
            (e) {
              PasswordModel model = PasswordModel.fromJson(e);
              model = model.copyWith(
                password:
                    SecurityUtils.decryptPassword(model.password, derivedKey),
              );

              if (model.id != null &&
                  model.name != null &&
                  model.vaultId != null) {
                searchList.add(
                  SearchModel(
                    id: model.id!,
                    title: model.name!,
                    subtitle: model.username,
                    type: SearchType.password.name,
                    vaultId: model.vaultId!,
                    imgUrl: model.typeImg,
                  ),
                );
              }

              return model;
            },
          );

          passwords.addAll(result);
        }

        emit(
          ChangeSearchState(
            state.model.copyWith(
              passwords: passwords,
            ),
          ),
        );
      },
    );

    final cardResponse = await cardRepository.searchCards(
      search: search,
    );

    cardResponse.fold(
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
          );
        }
        emit(
          ChangeSearchState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
              cards: cards,
            ),
          ),
        );
      },
    );

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
