import 'package:equatable/equatable.dart';
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

class DashboardStateModel extends Equatable {
  final int currentIndex;
  final DisplayNameForm displayName;

  const DashboardStateModel({
    this.currentIndex = 0,
    this.displayName = const DisplayNameForm.pure(),
  });

  DashboardStateModel copyWith({
    int? currentIndex,
    DisplayNameForm? displayName,
  }) {
    return DashboardStateModel(
      currentIndex: currentIndex ?? this.currentIndex,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object> get props => [
        currentIndex,
        displayName,
      ];
}
