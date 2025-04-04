import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_event.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_state.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';
import 'package:savepass/core/form/password_form.dart';

class MasterPasswordBloc
    extends Bloc<MasterPasswordEvent, MasterPasswordState> {
  MasterPasswordBloc() : super(const MasterPasswordInitialState()) {
    on<MasterPasswordInitialEvent>(_onMasterPasswordInitialEvent);
    on<OldPasswordChangedEvent>(_onOldPasswordChangedEvent);
    on<NewPasswordChangedEvent>(_onNewPasswordChangedEvent);
    on<RepeatPasswordChangedEvent>(_onRepeatPasswordChangedEvent);
    on<ToggleOldPasswordEvent>(_onToggleOldPasswordEvent);
    on<ToggleNewPasswordEvent>(_onToggleNewPasswordEvent);
    on<ToggleRepeatPasswordEvent>(_onToggleRepeatPasswordEvent);
    on<SubmitEvent>(_onSubmitEvent);
  }

  FutureOr<void> _onMasterPasswordInitialEvent(
    MasterPasswordInitialEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(const MasterPasswordInitialState());
  }

  FutureOr<void> _onOldPasswordChangedEvent(
    OldPasswordChangedEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(
          oldPassword: PasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onNewPasswordChangedEvent(
    NewPasswordChangedEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(
          newPassword: MasterPasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onRepeatPasswordChangedEvent(
    RepeatPasswordChangedEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(
          repeatNewPassword: MasterPasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitEvent(
    SubmitEvent event,
    Emitter<MasterPasswordState> emit,
  ) {}

  FutureOr<void> _onToggleOldPasswordEvent(
    ToggleOldPasswordEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(showOldPassword: !state.model.showOldPassword),
      ),
    );
  }

  FutureOr<void> _onToggleNewPasswordEvent(
    ToggleNewPasswordEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(showNewPassword: !state.model.showNewPassword),
      ),
    );
  }

  FutureOr<void> _onToggleRepeatPasswordEvent(
    ToggleRepeatPasswordEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(showRepeatNewPassword: !state.model.showRepeatNewPassword),
      ),
    );
  }
}
