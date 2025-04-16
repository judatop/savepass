import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_event.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Logger log;

  ProfileBloc({
    required this.log,
  }) : super(const ProfileInitialState()) {
    on<SaveDerivedKeyEvent>(_onSaveDerivedKeyEvent);
    on<SaveJwtEvent>(_onSaveJwtEvent);
    on<ClearValuesEvent>(_onClearValuesEvent);
  }

  FutureOr<void> _onSaveDerivedKeyEvent(
    SaveDerivedKeyEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      ChangeProfileState(
        state.model.copyWith(
          derivedKey: event.derivedKey,
        ),
      ),
    );
  }

  FutureOr<void> _onSaveJwtEvent(
    SaveJwtEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      ChangeProfileState(
        state.model.copyWith(
          jwt: event.jwt,
        ),
      ),
    );
  }

  FutureOr<void> _onClearValuesEvent(
    ClearValuesEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(const ProfileInitialState());
  }
}
