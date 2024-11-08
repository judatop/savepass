import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/sign_up/infrastructure/models/master_password_form.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_event.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_state.dart';
import 'package:savepass/core/global/domain/repositories/secret_repository.dart';
import 'package:uuid/uuid.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SecretRepository secretRepository;
  final ProfileRepository profileRepository;

  SyncBloc({
    required this.secretRepository,
    required this.profileRepository,
  }) : super(const SyncInitialState()) {
    on<SyncInitialEvent>(_onSyncInitial);
    on<SyncPasswordChangedEvent>(_onSyncPasswordChanged);
    on<SubmitSyncPasswordEvent>(_onSubmitSyncPassword);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
  }

  FutureOr<void> _onSyncInitial(
    SyncInitialEvent event,
    Emitter<SyncState> emit,
  ) {}

  FutureOr<void> _onSyncPasswordChanged(
    SyncPasswordChangedEvent event,
    Emitter<SyncState> emit,
  ) {
    emit(
      ChangeSyncState(
        state.model.copyWith(
          masterPassword: MasterPasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitSyncPassword(
    SubmitSyncPasswordEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(
      ChangeSyncState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.masterPassword,
    ])) {
      emit(
        ChangeSyncState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    final masterPassword = state.model.masterPassword.value;
    final uuid = const Uuid().v4();

    final secretResponse =
        await secretRepository.addSecret(secret: masterPassword, name: uuid);

    String? masterPasswordUuid;

    secretResponse.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        masterPasswordUuid = r;
      },
    );

    if (masterPasswordUuid == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final updateProfileResponse = await profileRepository
        .updateMasterPasswordUuid(uuid: masterPasswordUuid!);

    updateProfileResponse.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        emit(
          OpenHomeState(
            state.model.copyWith(status: FormzSubmissionStatus.success),
          ),
        );
      },
    );
  }

  FutureOr<void> _onToggleMasterPasswordEvent(
    ToggleMasterPasswordEvent event,
    Emitter<SyncState> emit,
  ) {
    emit(
      ChangeSyncState(
        state.model.copyWith(showPassword: !state.model.showPassword),
      ),
    );
  }
}
