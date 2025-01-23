import 'package:equatable/equatable.dart';
import 'package:savepass/core/form/text_form.dart';

abstract class CardState extends Equatable {
  final CardStateModel model;

  const CardState(this.model);

  @override
  List<Object> get props => [model];
}

class CardInitialState extends CardState {
  const CardInitialState() : super(const CardStateModel());
}

class ChangeCardState extends CardState {
  const ChangeCardState(super.model);
}

class GeneralErrorState extends CardState {
  const GeneralErrorState(super.model);
}

class LoadingCardState extends CardState {
  const LoadingCardState(super.model);
}

class CardStateModel extends Equatable {
  final TextForm cardNumber;
  final TextForm cardHolderName;
  final TextForm cardCvv;
  final TextForm expirationMonth;
  final TextForm expirationYear;
  final int step;
  final bool isUpdating;
  final bool alreadySubmitted;
  final bool showCardNumber;

  const CardStateModel({
    this.cardNumber = const TextForm.pure(),
    this.cardHolderName = const TextForm.pure(),
    this.cardCvv = const TextForm.pure(),
    this.expirationMonth = const TextForm.pure(),
    this.expirationYear = const TextForm.pure(),
    this.step = 0,
    this.isUpdating = false,
    this.alreadySubmitted = false,
    this.showCardNumber = false,
  });

  CardStateModel copyWith({
    TextForm? cardNumber,
    TextForm? cardHolderName,
    TextForm? cardCvv,
    TextForm? expirationMonth,
    TextForm? expirationYear,
    int? step,
    bool? isUpdating,
    bool? alreadySubmitted,
    bool? showCardNumber,
  }) {
    return CardStateModel(
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cardCvv: cardCvv ?? this.cardCvv,
      expirationMonth: expirationMonth ?? this.expirationMonth,
      expirationYear: expirationYear ?? this.expirationYear,
      step: step ?? this.step,
      isUpdating: isUpdating ?? this.isUpdating,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      showCardNumber: showCardNumber ?? this.showCardNumber,
    );
  }

  @override
  List<Object?> get props => [
        cardNumber,
        cardHolderName,
        cardCvv,
        expirationMonth,
        expirationYear,
        step,
        isUpdating,
        alreadySubmitted,
        showCardNumber,
      ];
}
