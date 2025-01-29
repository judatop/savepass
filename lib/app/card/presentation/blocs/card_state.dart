import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/infrastructure/models/card_cvv_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_exp_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/card/infrastructure/models/card_number_form.dart';
import 'package:savepass/app/card/infrastructure/models/card_type.dart';
import 'package:savepass/app/preferences/infrastructure/models/card_image_model.dart';
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

class MinLengthErrorCardState extends CardState {
  const MinLengthErrorCardState(super.model);
}

class CardCreatedState extends CardState{
  const CardCreatedState(super.model);
}

class CardStateModel extends Equatable {
  final CardNumberForm cardNumber;
  final TextForm cardHolderName;
  final CardCvvForm cardCvv;
  final CardExpForm expirationMonth;
  final CardExpForm expirationYear;
  final int step;
  final bool isUpdating;
  final bool alreadySubmitted;
  final CardType cardType;
  final FormzSubmissionStatus status;
  final List<CardImageModel> images;
  final CardImageModel? cardImgSelected;
  final CardModel? cardSelected;

  const CardStateModel({
    this.cardNumber = const CardNumberForm.pure(),
    this.cardHolderName = const TextForm.pure(),
    this.cardCvv = const CardCvvForm.pure(),
    this.expirationMonth = const CardExpForm.pure(),
    this.expirationYear = const CardExpForm.pure(),
    this.step = 1,
    this.isUpdating = false,
    this.alreadySubmitted = false,
    this.cardType = CardType.unknown,
    this.status = FormzSubmissionStatus.initial,
    this.images = const [],
    this.cardImgSelected,
    this.cardSelected,
  });

  CardStateModel copyWith({
    CardNumberForm? cardNumber,
    TextForm? cardHolderName,
    CardCvvForm? cardCvv,
    CardExpForm? expirationMonth,
    CardExpForm? expirationYear,
    int? step,
    bool? isUpdating,
    bool? alreadySubmitted,
    CardType? cardType,
    FormzSubmissionStatus? status,
    List<CardImageModel>? images,
    CardImageModel? cardImgSelected,
    CardModel? cardSelected,
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
      cardType: cardType ?? this.cardType,
      status: status ?? this.status,
      images: images ?? this.images,
      cardImgSelected: cardImgSelected ?? this.cardImgSelected,
      cardSelected: cardSelected ?? this.cardSelected,
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
        cardType,
        images,
        cardImgSelected,
        cardSelected,
      ];
}
