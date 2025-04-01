import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_event.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_state.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  BiometricBloc() : super(const BiometricInitialState()) {
    on<BiometricInitialEvent>(_onBiometricInitialEvent);
    on<SubmitBiometricEvent>(_onSubmitBiometricEvent);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<BiometricPasswordChangedEvent>(_onBiometricPasswordChangedEvent);
  }

  FutureOr<void> _onBiometricInitialEvent(
    BiometricInitialEvent event,
    Emitter<BiometricState> emit,
  ) {}

  FutureOr<void> _onSubmitBiometricEvent(
    SubmitBiometricEvent event,
    Emitter<BiometricState> emit,
  ) {}

  FutureOr<void> _onToggleMasterPasswordEvent(
    ToggleMasterPasswordEvent event,
    Emitter<BiometricState> emit,
  ) {
    emit(
      ChangeBiometricState(
        state.model.copyWith(showPassword: !state.model.showPassword),
      ),
    );
  }

  FutureOr<void> _onBiometricPasswordChangedEvent(
    BiometricPasswordChangedEvent event,
    Emitter<BiometricState> emit,
  ) {
    emit(
      ChangeBiometricState(
        state.model.copyWith(
          masterPassword: MasterPasswordForm.dirty(event.password),
        ),
      ),
    );
  }
}
