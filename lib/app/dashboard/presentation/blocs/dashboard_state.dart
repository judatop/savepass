import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
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

class PasswordObtainedState extends DashboardState {
  const PasswordObtainedState(super.model);
}

class DashboardStateModel extends Equatable {
  final int currentIndex;
  final TextForm displayName;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus displayNameStatus;
  final FormzSubmissionStatus deleteStatus;
  final ProfileEntity? profile;
  final TextForm homeSearch;
  final List<PasswordModel> passwords;
  final FormzSubmissionStatus passwordStatus;
  final List<CardModel> cards;
  final FormzSubmissionStatus cardStatus;

  const DashboardStateModel({
    this.currentIndex = 0,
    this.displayName = const TextForm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.displayNameStatus = FormzSubmissionStatus.initial,
    this.profile,
    this.deleteStatus = FormzSubmissionStatus.initial,
    this.homeSearch = const TextForm.pure(),
    this.passwords = const [],
    this.passwordStatus = FormzSubmissionStatus.initial,
    this.cards = const [],
    this.cardStatus = FormzSubmissionStatus.initial,
  });

  DashboardStateModel copyWith({
    int? currentIndex,
    TextForm? displayName,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? displayNameStatus,
    ProfileEntity? profile,
    FormzSubmissionStatus? deleteStatus,
    TextForm? homeSearch,
    List<PasswordModel>? passwords,
    FormzSubmissionStatus? passwordStatus,
    List<CardModel>? cards,
    FormzSubmissionStatus? cardStatus,
  }) {
    return DashboardStateModel(
      currentIndex: currentIndex ?? this.currentIndex,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      displayNameStatus: displayNameStatus ?? this.displayNameStatus,
      profile: profile ?? this.profile,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      homeSearch: homeSearch ?? this.homeSearch,
      passwords: passwords ?? this.passwords,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      cards: cards ?? this.cards,
      cardStatus: cardStatus ?? this.cardStatus,
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
        homeSearch,
        passwords,
        passwordStatus,
        cardStatus,
      ];
}
