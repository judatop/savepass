import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/card/infrastructure/models/card_type.dart';
import 'package:savepass/app/card/presentation/blocs/card_event.dart';
import 'package:savepass/app/card/presentation/blocs/card_state.dart';
import 'package:savepass/core/form/text_form.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final Logger log;

  CardBloc({
    required this.log,
  }) : super(const CardInitialState()) {
    on<CardInitialEvent>(_onCardInitialEvent);
    on<ChangeCardNumberEvent>(_onChangeCardNumberEvent);
    on<ChangeCardHolderEvent>(_onChangeCardHolderEvent);
    on<ChangeCardCvv>(_onChangeCardCvv);
    on<ChangeExpirationMonth>(_onChangeExpirationMonth);
    on<ChangeExpirationYear>(_onChangeExpirationYear);
    on<SubmitCardNumberEvent>(_onSubmitCardNumberEvent);
    on<SubmitCardHolderEvent>(_onSubmitCardHolderEvent);
    on<SubmitCardExpirationEvent>(_onSubmitCardExpirationEvent);
  }

  FutureOr<void> _onChangeCardNumberEvent(
    ChangeCardNumberEvent event,
    Emitter<CardState> emit,
  ) {

    final number = event.cardNumber;

    CardType cardType = CardType.unknown;

    if(number.startsWith('4')){
      cardType = CardType.visa;
    }else if(number.startsWith('51') || number.startsWith('55')){
      cardType = CardType.masterCard;
    } else if(number.startsWith('34') || number.startsWith('37')){
      cardType = CardType.americanExpress;
    } else if(number.startsWith('36') || number.startsWith('38')){
      cardType = CardType.dinersClub;
    }


    emit(
      ChangeCardState(
        state.model.copyWith(
          cardNumber: TextForm.dirty(
            event.cardNumber,
          ),
          cardType: cardType,
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
    ChangeCardCvv event,
    Emitter<CardState> emit,
  ) {}

  FutureOr<void> _onChangeExpirationMonth(
    ChangeExpirationMonth event,
    Emitter<CardState> emit,
  ) {
    emit(
      ChangeCardState(
        state.model.copyWith(
          expirationMonth: TextForm.dirty(
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
          expirationYear: TextForm.dirty(
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
      const ChangeCardState(CardStateModel()),
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

    final cardNumber = state.model.cardNumber.value;

    if (cardNumber.length < 12) {
      emit(MinLengthErrorCardState(state.model));
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
}
