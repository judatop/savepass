import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/biometric/domain/repositories/biometric_repository.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/infraestructure/models/insert_master_password_model.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_event.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_event.dart';
import 'package:savepass/app/sync_pass/presentation/blocs/sync_state.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/global/utils/secret_utils.dart';
import 'package:savepass/core/utils/biometric_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/security_utils.dart';
import 'package:uuid/uuid.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final ProfileRepository profileRepository;
  final DeviceInfo deviceInfo;
  final PreferencesRepository preferencesRepository;
  final BiometricUtils biometricUtils;
  final AuthInitRepository authInitRepository;
  final BiometricRepository biometricRepository;
  final FlutterSecureStorage secureStorage;
  final Logger log;

  SyncBloc({
    required this.profileRepository,
    required this.deviceInfo,
    required this.preferencesRepository,
    required this.biometricUtils,
    required this.authInitRepository,
    required this.biometricRepository,
    required this.secureStorage,
    required this.log,
  }) : super(const SyncInitialState()) {
    on<SyncInitialEvent>(_onSyncInitial);
    on<SyncPasswordChangedEvent>(_onSyncPasswordChanged);
    on<SubmitSyncPasswordEvent>(_onSubmitSyncPassword);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<EnrollBiometricsEvent>(_onEnrollBiometricsEvent);
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

    final hasShownEnrollBiometricsDialogResult =
        await preferencesRepository.getHasShownEnrollBiometricsDialog();
    late bool hasShownEnrollBiometricsDialog = false;

    hasShownEnrollBiometricsDialogResult.fold(
      (l) {
        hasShownEnrollBiometricsDialog = false;
      },
      (r) {
        hasShownEnrollBiometricsDialog = r;
      },
    );
    final hasBiometricsSaved = await biometricUtils.hasBiometricsSaved();
    final canAuthenticateWithBiometrics =
        await biometricUtils.canAuthenticateWithBiometrics();

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

        if (!hasShownEnrollBiometricsDialog &&
            !hasBiometricsSaved &&
            canAuthenticateWithBiometrics) {
          emit(
            OpenBiometricsEnrollmentState(
              state.model.copyWith(status: FormzSubmissionStatus.success),
            ),
          );
          return;
        }

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

  FutureOr<void> _onEnrollBiometricsEvent(
    EnrollBiometricsEvent event,
    Emitter<SyncState> emit,
  ) async {
    try {
      await preferencesRepository.setHasShownEnrollBiometricsDialog(true);

      emit(
        ChangeSyncState(
          state.model.copyWith(
            alreadySubmitted: true,
            status: FormzSubmissionStatus.inProgress,
          ),
        ),
      );

      if (!event.enroll) {
        emit(
          OpenHomeState(
            state.model.copyWith(status: FormzSubmissionStatus.success),
          ),
        );
        return;
      }

      final isAuthenticated = await biometricUtils.authenticate();

      if (!isAuthenticated) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final saltResponse = await authInitRepository.getUserSalt();
      late String? salt;
      saltResponse.fold(
        (l) {
          salt = null;
        },
        (r) {
          salt = r.data?['salt'];
        },
      );

      if (salt == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final clearMasterPassword = state.model.masterPassword.value.trim();
      final derivedKey =
          await SecurityUtils.deriveMasterKey(clearMasterPassword, salt!, 32);
      final hashedPassword = SecurityUtils.hashMasterKey(derivedKey);
      final deviceId = await deviceInfo.getDeviceId();

      if (deviceId == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final response = await biometricRepository.enrollBiometric(
        inputSecret: hashedPassword,
        deviceId: deviceId,
      );

      late final String? code;
      late final Map<String, dynamic>? data;
      response.fold(
        (l) {
          code = null;
        },
        (r) {
          code = r.code;
          data = r.data;
        },
      );

      if (code == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      if (data == null || code == ApiCodes.alreadyHasDeviceEnrolled) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      if (code == ApiCodes.invalidMasterPassword) {
        emit(
          InvalidMasterPasswordState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      if (code != ApiCodes.success) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final biometricHash = data!['hash'];
      await secureStorage.write(
        key: Env.biometricHashKey,
        value: biometricHash,
      );
      await secureStorage.write(
        key: Env.derivedKey,
        value: base64Encode(derivedKey),
      );

      emit(
        BiometricsEnrolledState(
          state.model.copyWith(status: FormzSubmissionStatus.success),
        ),
      );
    } catch (e, stackTrace) {
      log.severe('Exception _onEnrollBiometricsEvent: $e', e, stackTrace);
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
    }
  }
}
