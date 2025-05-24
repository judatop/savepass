import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/infraestructure/models/insert_master_password_model.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_event.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_event.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_state.dart';
import 'package:savepass/core/global/utils/secret_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/security_utils.dart';
import 'package:uuid/uuid.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final ProfileRepository profileRepository;
  final DeviceInfo deviceInfo;

  SyncBloc({
    required this.profileRepository,
    required this.deviceInfo,
  }) : super(const SyncInitialState()) {
    on<SyncInitialEvent>(_onSyncInitial);
    on<SyncPasswordChangedEvent>(_onSyncPasswordChanged);
    on<SubmitSyncPasswordEvent>(_onSubmitSyncPassword);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
  }

  FutureOr<void> _onSyncInitial(
    SyncInitialEvent event,
    Emitter<SyncState> emit,
  ) {
    emit(const SyncInitialState());
  }

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

    final clearMasterPassword = state.model.masterPassword.value;
    final name = '${const Uuid().v4()}-${SecretUtils.masterPasswordKey}';
    final salt = SecurityUtils.generateSalt(16);
    final derivedKey =
        await SecurityUtils.deriveMasterKey(clearMasterPassword, salt, 32);
    final hashedPassword = SecurityUtils.hashMasterKey(derivedKey);
    final deviceId = await deviceInfo.getDeviceId();
    final deviceName = await deviceInfo.getDeviceName();
    final deviceType = deviceInfo.getDeviceType();

    if (deviceId == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final updateProfileResponse = await profileRepository.insertMasterPassword(
      model: InsertMasterPasswordModel(
        secret: hashedPassword,
        name: name,
        deviceId: deviceId,
        deviceName: deviceName,
        type: deviceType,
        salt: salt,
      ),
    );

    updateProfileResponse.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        if (r.data == null) {
          emit(
            GeneralErrorState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
          return;
        }

        final profileBloc = Modular.get<ProfileBloc>();
        profileBloc.add(SaveDerivedKeyEvent(derivedKey: derivedKey));
        profileBloc.add(SaveJwtEvent(jwt: r.data!['jwt']));

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
