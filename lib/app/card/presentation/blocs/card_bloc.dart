import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/card/presentation/blocs/card_event.dart';
import 'package:savepass/app/card/presentation/blocs/card_state.dart';
import 'package:savepass/app/card/utils/card_utils.dart';
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
  }

  FutureOr<void> _onChangeCardNumberEvent(
    ChangeCardNumberEvent event,
    Emitter<CardState> emit,
  ) {
    emit(
      ChangeCardState(
        state.model.copyWith(
          cardNumber: TextForm.dirty(
            event.cardNumber,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeCardHolderEvent(
    ChangeCardHolderEvent event,
    Emitter<CardState> emit,
  ) {}

  FutureOr<void> _onChangeCardCvv(
    ChangeCardCvv event,
    Emitter<CardState> emit,
  ) {}

  FutureOr<void> _onChangeExpirationMonth(
    ChangeExpirationMonth event,
    Emitter<CardState> emit,
  ) {}

  FutureOr<void> _onChangeExpirationYear(
    ChangeExpirationYear event,
    Emitter<CardState> emit,
  ) {}

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
      emit(GeneralErrorState(state.model)); //TODO: Replace with custom error
      return;
    }

    emit(
      ChangeCardState(
        state.model.copyWith(
          cardNumber:
              TextForm.dirty(CardUtils.formatCreditCardNumber(cardNumber)),
          showCardNumber: true,
        ),
      ),
    );
  }
}
