import 'package:equatable/equatable.dart';

abstract class CardEvent extends Equatable {
  const CardEvent();

  @override
  List<Object> get props => [];
}

class CardInitialEvent extends CardEvent {

  const CardInitialEvent() : super();
}

class CardInitDataEvent extends CardEvent {
  final String? cardId;

  const CardInitDataEvent({this.cardId}) : super();
}

class ChangeCardNumberEvent extends CardEvent {
  final String cardNumber;

  const ChangeCardNumberEvent({required this.cardNumber}) : super();
}

class ChangeCardHolderEvent extends CardEvent {
  final String cardHolderName;

  const ChangeCardHolderEvent({required this.cardHolderName}) : super();
}

class ChangeCardCvvEvent extends CardEvent {
  final String cardCvv;

  const ChangeCardCvvEvent({required this.cardCvv}) : super();
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

class SubmitCardHolderEvent extends CardEvent {
  const SubmitCardHolderEvent() : super();
}

class SubmitCardExpirationEvent extends CardEvent {
  const SubmitCardExpirationEvent() : super();
}

class SubmitCardEvent extends CardEvent {
  const SubmitCardEvent() : super();
}

class SubmitEditCardEvent extends CardEvent{
  const SubmitEditCardEvent() : super();
}

class GetCardValueEvent extends CardEvent {
  final String vaultId;
  final int index;

  const GetCardValueEvent({
    required this.vaultId,
    required this.index,
  }) : super();
}

class DeleteCardEvent extends CardEvent{
  const DeleteCardEvent() : super();
}


class CopyCardNumberClipboardEvent extends CardEvent{
  const CopyCardNumberClipboardEvent() : super();
}

class CopyCardHoldernameClipboardEvent extends CardEvent{
  const CopyCardHoldernameClipboardEvent() : super();
}