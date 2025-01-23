import 'package:equatable/equatable.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object> get props => [];
}

class CardInitialEvent extends CardEvent {
  final String? cardId;

  const CardInitialEvent({this.cardId}) : super();
}

class ChangeCardNumberEvent extends CardEvent {
  final String cardNumber;

  const ChangeCardNumberEvent({required this.cardNumber}) : super();
}

class ChangeCardHolderEvent extends CardEvent {
  final String cardHolderName;

  const ChangeCardHolderEvent({required this.cardHolderName}) : super();
}

class ChangeCardCvv extends CardEvent {
  final String cardCvv;

  const ChangeCardCvv({required this.cardCvv}) : super();
}

class ChangeExpirationMonth extends CardEvent {
  final String expirationMonth;

  const ChangeExpirationMonth({required this.expirationMonth}) : super();
}

class ChangeExpirationYear extends CardEvent {
  final String expirationYear;

  const ChangeExpirationYear({required this.expirationYear}) : super();
}

class SubmitCardNumberEvent extends CardEvent {
  const SubmitCardNumberEvent() : super();
}
