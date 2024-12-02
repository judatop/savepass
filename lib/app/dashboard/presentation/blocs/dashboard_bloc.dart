import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/dashboard/infrastructure/models/display_name_form.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Logger log;

  DashboardBloc({
    required this.log,
  }) : super(const DashboardInitialState()) {
    on<DashboardInitialEvent>(_onDashboardInitialEvent);
    on<ChangeIndexEvent>(_onChangeIndexEvent);
    on<ChangeDisplayNameEvent>(_onChangeDisplayNameEvent);
  }

  FutureOr<void> _onDashboardInitialEvent(
    DashboardInitialEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(const DashboardInitialState());
  }

  FutureOr<void> _onChangeIndexEvent(
    ChangeIndexEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(ChangeDashboardState(state.model.copyWith(currentIndex: event.index)));
  }

  FutureOr<void> _onChangeDisplayNameEvent(
    ChangeDisplayNameEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      ChangeDashboardState(
        state.model.copyWith(
          displayName: DisplayNameForm.dirty(event.displayName),
        ),
      ),
    );
  }
}
