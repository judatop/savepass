import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_cvv_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_exp_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/card/infrastructure/models/card_number_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_type.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_event.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_state.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/infrastructure/models/card_image_model.dart';
import 'package:savepass/core/form/text_form.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final Logger log;
  final PreferencesRepository preferencesRepository;
  final CardRepository cardRepository;

  CardBloc({
    required this.log,
    required this.preferencesRepository,
    required this.cardRepository,
  }) : super(const CardInitialState()) {
    on<CardInitialEvent>(_onCardInitialEvent);
    on<CardInitDataEvent>(_onCardInitDataEvent);
    on<ChangeCardNumberEvent>(_onChangeCardNumberEvent);
    on<ChangeCardHolderEvent>(_onChangeCardHolderEvent);
    on<ChangeCardCvvEvent>(_onChangeCardCvv);
    on<ChangeExpirationMonth>(_onChangeExpirationMonth);
    on<ChangeExpirationYear>(_onChangeExpirationYear);
    on<SubmitCardNumberEvent>(_onSubmitCardNumberEvent);
    on<SubmitCardHolderEvent>(_onSubmitCardHolderEvent);
    on<SubmitCardExpirationEvent>(_onSubmitCardExpirationEvent);
    on<SubmitCardEvent>(_onSubmitCardEvent);
    on<SubmitEditCardEvent>(_onSubmitEditCardEvent);
    on<DeleteCardEvent>(_onDeleteCardEvent);
    on<CopyCardNumberClipboardEvent>(_onCopyCardNumberClipboardEvent);
    on<CopyCardHoldernameClipboardEvent>(_onCopyCardHoldernameClipboardEvent);
  }

  CardType getCardType(String number) {
    CardType cardType = CardType.unknown;

    if (number.startsWith('4')) {
      cardType = CardType.visa;
    } else if (number.startsWith('51') || number.startsWith('55')) {
      cardType = CardType.masterCard;
    } else if (number.startsWith('34') || number.startsWith('37')) {
      cardType = CardType.americanExpress;
    } else if (number.startsWith('6011')) {
      cardType = CardType.discover;
    } else if (number.startsWith('36') || number.startsWith('38')) {
      cardType = CardType.dinersClub;
    }

    return cardType;
  }

  FutureOr<void> _onChangeCardNumberEvent(
    ChangeCardNumberEvent event,
    Emitter<CardState> emit,
  ) {
    final number = event.cardNumber;

    CardType cardType = getCardType(number);

    CardImageModel? selected;
    for (CardImageModel m in state.model.images) {
      if (m.type == cardType.stringValue) {
        selected = m;
        break;
      }
    }

    emit(
      ChangeCardState(
        state.model.copyWith(
          cardNumber: CardNumberForm.dirty(
            event.cardNumber,
          ),
          cardType: cardType,
          cardImgSelected: selected,
        ),
      ),
    );
  }

  FutureOr<void> _onChangeCardHolderEvent(
    ChangeCardHolderEvent event,
    Emitter<CardState> emit,
  ) {
    emit(
      ChangeCardState(
        state.model.copyWith(
          cardHolderName: TextForm.dirty(
            event.cardHolderName,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeCardCvv(
    ChangeCardCvvEvent event,
    Emitter<CardState> emit,
  ) {
    emit(
      ChangeCardState(
        state.model.copyWith(
          cardCvv: CardCvvForm.dirty(
            event.cardCvv,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeExpirationMonth(
    ChangeExpirationMonth event,
    Emitter<CardState> emit,
  ) {
    emit(
      ChangeCardState(
        state.model.copyWith(
          expirationMonth: CardExpForm.dirty(
            event.expirationMonth,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeExpirationYear(
    ChangeExpirationYear event,
    Emitter<CardState> emit,
  ) {
    emit(
      ChangeCardState(
        state.model.copyWith(
          expirationYear: CardExpForm.dirty(
            event.expirationYear,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onCardInitialEvent(
    CardInitialEvent event,
    Emitter<CardState> emit,
  ) {
    emit(
      const ChangeCardState(
        CardStateModel(),
      ),
    );
  }

  FutureOr<void> _onCardInitDataEvent(
    CardInitDataEvent event,
    Emitter<CardState> emit,
  ) async {
    final isUpdating = event.cardId != null;

    emit(
      ChangeCardState(
        CardStateModel(
          isUpdating: isUpdating,
          status: isUpdating
              ? FormzSubmissionStatus.inProgress
              : FormzSubmissionStatus.initial,
        ),
      ),
    );

    final response = await preferencesRepository.getCardImages();

    List<CardImageModel> imgs = [];

    response.fold(
      (l) {},
      (r) {
        imgs = r;
      },
    );

    if (isUpdating) {
      final response = await cardRepository.getCardModel(event.cardId!);

      late CardModel? cardModel;
      response.fold(
        (l) {
          cardModel = null;
        },
        (r) {
          cardModel = r;
        },
      );

      if (cardModel == null) {
        emit(
          ErrorLoadingCardState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
        return;
      }

      final cardRes = await cardRepository.getCard(cardModel!.card);

      late String? cardValues;

      cardRes.fold(
        (l) {
          cardValues = null;
        },
        (r) {
          cardValues = r;
        },
      );

      if (cardValues == null) {
        emit(
          ErrorLoadingCardState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
        return;
      }

      final values = cardValues!.split('|');
      final cardNumber = values[0];
      final cardHoldername = values[1];
      final cardExpirationMonth = values[2].split('/')[0];
      final cardExpirationYear = values[2].split('/')[1];
      final cardCvv = values[3];

      CardType cardType = getCardType(cardNumber);
      CardImageModel? selectedImgModel;
      if (isUpdating) {
        for (CardImageModel imageModel in imgs) {
          if (imageModel.id == cardModel?.type) {
            selectedImgModel = imageModel;
            break;
          }
        }
      }

      emit(
        ChangeCardState(
          state.model.copyWith(
            status: FormzSubmissionStatus.success,
            cardSelected: cardModel,
            cardNumber: CardNumberForm.dirty(cardNumber),
            cardHolderName: TextForm.dirty(cardHoldername),
            expirationMonth: CardExpForm.dirty(cardExpirationMonth),
            expirationYear: CardExpForm.dirty(cardExpirationYear),
            cardCvv: CardCvvForm.dirty(cardCvv),
            isUpdating: isUpdating,
            cardImgSelected: selectedImgModel,
            cardType: cardType,
          ),
        ),
      );
    }

    emit(
      ChangeCardState(
        state.model.copyWith(
          images: imgs,
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitCardNumberEvent(
    SubmitCardNumberEvent event,
    Emitter<CardState> emit,
  ) async {
    emit(
      ChangeCardState(
        state.model.copyWith(
          alreadySubmitted: true,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.cardNumber,
    ])) {
      return;
    }

    emit(
      ChangeCardState(
        state.model.copyWith(
          step: 2,
          alreadySubmitted: false,
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitCardHolderEvent(
    SubmitCardHolderEvent event,
    Emitter<CardState> emit,
  ) async {
    emit(
      ChangeCardState(
        state.model.copyWith(
          alreadySubmitted: true,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.cardHolderName,
    ])) {
      return;
    }

    emit(
      ChangeCardState(
        state.model.copyWith(
          step: 3,
          alreadySubmitted: false,
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitCardExpirationEvent(
    SubmitCardExpirationEvent event,
    Emitter<CardState> emit,
  ) async {
    emit(
      ChangeCardState(
        state.model.copyWith(
          alreadySubmitted: true,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.expirationMonth,
      state.model.expirationYear,
    ])) {
      return;
    }

    emit(
      ChangeCardState(
        state.model.copyWith(
          step: 4,
          alreadySubmitted: false,
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitCardEvent(
    SubmitCardEvent event,
    Emitter<CardState> emit,
  ) async {
    emit(
      ChangeCardState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.cardCvv,
    ])) {
      emit(
        ChangeCardState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final type = state.model.cardImgSelected?.id;
    final card =
        '${state.model.cardNumber.value}|${state.model.cardHolderName.value}|${state.model.expirationMonth.value}/${state.model.expirationYear.value}|${state.model.cardCvv.value}';

    final response =
        await cardRepository.insertCard(CardModel(type: type, card: card));

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
          CardCreatedState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onSubmitEditCardEvent(
    SubmitEditCardEvent event,
    Emitter<CardState> emit,
  ) async {
    emit(
      ChangeCardState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.cardNumber,
      state.model.cardHolderName,
      state.model.expirationMonth,
      state.model.expirationYear,
      state.model.cardCvv,
    ])) {
      emit(
        ChangeCardState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final type = state.model.cardImgSelected?.id;
    final card =
        '${state.model.cardNumber.value}|${state.model.cardHolderName.value}|${state.model.expirationMonth.value}/${state.model.expirationYear.value}|${state.model.cardCvv.value}';
    final cardSelected = state.model.cardSelected;

    final response = await cardRepository.editCard(
      CardModel(id: cardSelected!.id, type: type, card: card),
      cardSelected.card,
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
        emit(
          CardEditedState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onDeleteCardEvent(
    DeleteCardEvent event,
    Emitter<CardState> emit,
  ) async {
    if (state.model.isUpdating) {
      emit(
        ChangeCardState(
          state.model.copyWith(
            status: FormzSubmissionStatus.inProgress,
          ),
        ),
      );

      final passwordId = state.model.cardSelected!.id!;
      final vaultId = state.model.cardSelected!.card;

      final response = await cardRepository.deleteCard(passwordId, vaultId);

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
            CardDeletedState(
              state.model.copyWith(
                status: FormzSubmissionStatus.success,
              ),
            ),
          );
        },
      );
    }
  }

  FutureOr<void> _onCopyCardNumberClipboardEvent(
    CopyCardNumberClipboardEvent event,
    Emitter<CardState> emit,
  ) async {
    final user = state.model.cardNumber.value;

    await Clipboard.setData(ClipboardData(text: user));

    emit(
      CardNumberCopiedState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> _onCopyCardHoldernameClipboardEvent(
    CopyCardHoldernameClipboardEvent event,
    Emitter<CardState> emit,
  ) async {
    final user = state.model.cardHolderName.value;

    await Clipboard.setData(ClipboardData(text: user));

    emit(
      CardHoldernameCopiedState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );
  }
}
