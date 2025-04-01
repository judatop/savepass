import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/biometric/domain/repositories/biometric_repository.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_event.dart';
import 'package:savepass/app/biometric/presentation/blocs/biometric_state.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/security_utils.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final AuthInitRepository authInitRepository;
  final BiometricRepository biometricRepository;
  final FlutterSecureStorage secureStorage;

  BiometricBloc({
    required this.authInitRepository,
    required this.biometricRepository,
    required this.secureStorage,
  }) : super(const BiometricInitialState()) {
    on<BiometricInitialEvent>(_onBiometricInitialEvent);
    on<SubmitBiometricEvent>(_onSubmitBiometricEvent);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<BiometricPasswordChangedEvent>(_onBiometricPasswordChangedEvent);
  }

  FutureOr<void> _onBiometricInitialEvent(
    BiometricInitialEvent event,
    Emitter<BiometricState> emit,
  ) async {
    emit(
      ChangeBiometricState(
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
        ChangeBiometricState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
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

    final clearMasterPassword = state.model.masterPassword.value;
    final derivedKey =
        SecurityUtils.deriveMasterKey(clearMasterPassword, salt!, 32);
    final hashedPassword = SecurityUtils.hashMasterKey(derivedKey);
    final deviceId = await DeviceInfo.getDeviceId();

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

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        if (r.data == null || r.code == ApiCodes.alreadyHasDeviceEnrolled) {
          emit(
            GeneralErrorState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
          return;
        }

        if (r.code == ApiCodes.invalidMasterPassword) {
          emit(
            InvalidMasterPasswordState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
          return;
        }

        final biometricHash = r.data!['hash'];
        secureStorage.write(key: Env.biometricHashKey, value: biometricHash);

        emit(
          EnrolledSuccessfulState(
            state.model.copyWith(status: FormzSubmissionStatus.success),
          ),
        );
      },
    );
  }

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
