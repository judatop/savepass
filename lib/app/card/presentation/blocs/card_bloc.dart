import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/card/infrastructure/models/card_cvv_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_exp_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_number_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_type.dart';
import 'package:savepass/app/card/presentation/blocs/card_event.dart';
import 'package:savepass/app/card/presentation/blocs/card_state.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/infrastructure/models/card_image_model.dart';
import 'package:savepass/core/form/text_form.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final Logger log;
  final PreferencesRepository preferencesRepository;

  CardBloc({
    required this.log,
    required this.preferencesRepository,
  }) : super(const CardInitialState()) {
    on<CardInitialEvent>(_onCardInitialEvent);
    on<ChangeCardNumberEvent>(_onChangeCardNumberEvent);
    on<ChangeCardHolderEvent>(_onChangeCardHolderEvent);
    on<ChangeCardCvvEvent>(_onChangeCardCvv);
    on<ChangeExpirationMonth>(_onChangeExpirationMonth);
    on<ChangeExpirationYear>(_onChangeExpirationYear);
    on<SubmitCardNumberEvent>(_onSubmitCardNumberEvent);
    on<SubmitCardHolderEvent>(_onSubmitCardHolderEvent);
    on<SubmitCardExpirationEvent>(_onSubmitCardExpirationEvent);
    on<SubmitCvvEvent>(_onSubmitCvvEvent);
  }

  FutureOr<void> _onChangeCardNumberEvent(
    ChangeCardNumberEvent event,
    Emitter<CardState> emit,
  ) {
    final number = event.cardNumber;

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
  ) async {
    emit(
      const ChangeCardState(CardStateModel()),
    );

    final response = await preferencesRepository.getCardImages();

    response.fold(
      (l) {},
      (r) {
        emit(
          ChangeCardState(
            state.model.copyWith(
              images: r,
            ),
          ),
        );
      },
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

  FutureOr<void> _onSubmitCvvEvent(
    SubmitCvvEvent event,
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

    //TODO: Save card on Supabase

    emit(
      ChangeCardState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );
  }
}
