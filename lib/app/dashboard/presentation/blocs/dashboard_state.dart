import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/dashboard/infrastructure/models/display_name_form.dart';

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

class DashboardStateModel extends Equatable {
  final int currentIndex;
  final DisplayNameForm displayName;
  final FormzSubmissionStatus status;

  const DashboardStateModel({
    this.currentIndex = 0,
    this.displayName = const DisplayNameForm.pure(),
    this.status = FormzSubmissionStatus.initial,
  });

  DashboardStateModel copyWith({
    int? currentIndex,
    DisplayNameForm? displayName,
    FormzSubmissionStatus? status,
  }) {
    return DashboardStateModel(
      currentIndex: currentIndex ?? this.currentIndex,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        currentIndex,
        displayName,
        status,
      ];
}
