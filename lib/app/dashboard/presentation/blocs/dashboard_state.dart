import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';

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

class DashboardStateModel extends Equatable {
  final int currentIndex;
  final String displayName;
  final FormzSubmissionStatus status;
  final FormzSubmissionStatus displayNameStatus;
  final ProfileEntity? profile;

  const DashboardStateModel({
    this.currentIndex = 0,
    this.displayName = '',
    this.status = FormzSubmissionStatus.initial,
    this.displayNameStatus = FormzSubmissionStatus.initial,
    this.profile,
  });

  DashboardStateModel copyWith({
    int? currentIndex,
    String? displayName,
    FormzSubmissionStatus? status,
    FormzSubmissionStatus? displayNameStatus,
    ProfileEntity? profile,
  }) {
    return DashboardStateModel(
      currentIndex: currentIndex ?? this.currentIndex,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      displayNameStatus: displayNameStatus ?? this.displayNameStatus,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [
        currentIndex,
        displayName,
        status,
        displayNameStatus,
        profile,
      ];
}
