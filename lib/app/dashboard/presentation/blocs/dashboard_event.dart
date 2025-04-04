import 'package:equatable/equatable.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardInitialEvent extends DashboardEvent {
  const DashboardInitialEvent() : super();
}

class ChangeIndexEvent extends DashboardEvent {
  final int index;

  const ChangeIndexEvent({required this.index}) : super();
}

class ChangeDisplayNameEvent extends DashboardEvent {
  final String displayName;

  const ChangeDisplayNameEvent({required this.displayName}) : super();
}

class SaveDisplayNameEvent extends DashboardEvent {
  const SaveDisplayNameEvent() : super();
}

class ChangeAvatarEvent extends DashboardEvent {
  const ChangeAvatarEvent() : super();
}

class UploadPhotoEvent extends DashboardEvent {
  const UploadPhotoEvent() : super();
}

class OpenPrivacyPolicyEvent extends DashboardEvent {
  const OpenPrivacyPolicyEvent() : super();
}

class OpenTermsEvent extends DashboardEvent {
  const OpenTermsEvent() : super();
}

class DeleteAccountEvent extends DashboardEvent {
  const DeleteAccountEvent() : super();
}

class LogOutEvent extends DashboardEvent {
  const LogOutEvent() : super();
}

class OnClickNewPassword extends DashboardEvent {
  const OnClickNewPassword() : super();
}

class OnClickNewCard extends DashboardEvent {
  const OnClickNewCard() : super();
}

class CopyPasswordEvent extends DashboardEvent {
  final PasswordModel password;

  const CopyPasswordEvent({required this.password}) : super();
}

class OpenSearchEvent extends DashboardEvent {
  const OpenSearchEvent() : super();
}

class GetCardValueEvent extends DashboardEvent {
  final CardModel card;
  final int index;

  const GetCardValueEvent({
    required this.card,
    required this.index,
  }) : super();
}

class CheckBiometricsEvent extends DashboardEvent {
  const CheckBiometricsEvent() : super();
}

class GetProfileEvent extends DashboardEvent{
  const GetProfileEvent() : super();
}

class GetCardsEvent extends DashboardEvent{
  const GetCardsEvent() : super();
}

class GetPasswordsEvent extends DashboardEvent{
  const GetPasswordsEvent() : super();
}

class CheckSupabaseBiometricsEvent extends DashboardEvent{
  const CheckSupabaseBiometricsEvent() : super();
}