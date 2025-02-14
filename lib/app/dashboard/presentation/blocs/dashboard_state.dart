import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/infrastructure/models/dashboard_card_model.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';
import 'package:savepass/core/form/text_form.dart';

abstract class DashboardState extends Equatable {
  final DashboardStateModel model;

  const DashboardState(this.model);

  @override
  List<Object> get props => [model];
}

class DashboardInitialState extends DashboardState {
  const DashboardInitialState() : super(const DashboardStateModel());
}

class ChangeDashboardState extends DashboardState {
  const ChangeDashboardState(super.model);
}

class OpenPhotoPermissionState extends DashboardState {
  const OpenPhotoPermissionState(super.model);
}

class GeneralErrorState extends DashboardState {
  const GeneralErrorState(super.model);
}

class LoadingDashboardState extends DashboardState {
  const LoadingDashboardState(super.model);
}

class UploadAvatarFailedState extends DashboardState {
  const UploadAvatarFailedState(super.model);
}

class UploadAvatarSuccessState extends DashboardState {
  const UploadAvatarSuccessState(super.model);
}

class LogOutState extends DashboardState {
  const LogOutState(super.model);
}

class OpenPasswordState extends DashboardState {
  const OpenPasswordState(super.model);
}

class OpenCardState extends DashboardState {
  const OpenCardState(super.model);
}

class PasswordObtainedState extends DashboardState {
  const PasswordObtainedState(super.model);
}

class CardValueCopiedState extends DashboardState {
  const CardValueCopiedState(super.model);
}

class OpenSearchState extends DashboardState {
  const OpenSearchState(super.model);
}

class UnauthenticatedBiometricsState extends DashboardState{
  const UnauthenticatedBiometricsState(super.model);
}

class AuthenticatedBiometricsState extends DashboardState{
  const AuthenticatedBiometricsState(super.model);
}

class DashboardStateModel extends Equatable {
  final int currentIndex;
  final TextForm displayName;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus displayNameStatus;
  final FormzSubmissionStatus deleteStatus;
  final ProfileEntity? profile;
  final List<PasswordModel> passwords;
  final FormzSubmissionStatus passwordStatus;
  final List<DashboardCardModel> cards;
  final FormzSubmissionStatus cardStatus;
  final FormzSubmissionStatus statusCardValue;
  final bool hasBiometrics;
  final bool canAuthenticate;


  const DashboardStateModel({
    this.currentIndex = 0,
    this.displayName = const TextForm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.displayNameStatus = FormzSubmissionStatus.initial,
    this.profile,
    this.deleteStatus = FormzSubmissionStatus.initial,
    this.passwords = const [],
    this.passwordStatus = FormzSubmissionStatus.initial,
    this.cards = const [],
    this.cardStatus = FormzSubmissionStatus.initial,
    this.statusCardValue = FormzSubmissionStatus.initial,
    this.hasBiometrics = false,
    this.canAuthenticate = false,
  });

  DashboardStateModel copyWith({
    int? currentIndex,
    TextForm? displayName,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? displayNameStatus,
    ProfileEntity? profile,
    FormzSubmissionStatus? deleteStatus,
    List<PasswordModel>? passwords,
    FormzSubmissionStatus? passwordStatus,
    List<DashboardCardModel>? cards,
    FormzSubmissionStatus? cardStatus,
    FormzSubmissionStatus? statusCardValue,
    bool? hasBiometrics,
    bool? canAuthenticate,
  }) {
    return DashboardStateModel(
      currentIndex: currentIndex ?? this.currentIndex,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      displayNameStatus: displayNameStatus ?? this.displayNameStatus,
      profile: profile ?? this.profile,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      passwords: passwords ?? this.passwords,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      cards: cards ?? this.cards,
      cardStatus: cardStatus ?? this.cardStatus,
      statusCardValue: statusCardValue ?? this.statusCardValue,
      hasBiometrics: hasBiometrics ?? this.hasBiometrics,
      canAuthenticate: canAuthenticate ?? this.canAuthenticate,
    );
  }

  @override
  List<Object?> get props => [
        currentIndex,
        displayName,
        status,
        displayNameStatus,
        profile,
        deleteStatus,
        passwords,
        passwordStatus,
        cardStatus,
        statusCardValue,
        hasBiometrics,
        canAuthenticate,
      ];
}
