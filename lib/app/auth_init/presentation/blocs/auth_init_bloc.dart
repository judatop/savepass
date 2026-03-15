import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_event.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_state.dart';
import 'package:savepass/app/biometric/domain/repositories/biometric_repository.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_event.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/utils/biometric_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/security_utils.dart';

class AuthInitBloc extends Bloc<AuthInitEvent, AuthInitState> {
  final ProfileRepository profileRepository;
  final AuthInitRepository authInitRepository;
  final BiometricUtils biometricUtils;
  final Logger log;
  final FlutterSecureStorage secureStorage;
  final DeviceInfo deviceInfo;
  final PreferencesRepository preferencesRepository;
  final BiometricRepository biometricRepository;

  AuthInitBloc({
    required this.profileRepository,
    required this.authInitRepository,
    required this.biometricUtils,
    required this.log,
    required this.secureStorage,
    required this.deviceInfo,
    required this.preferencesRepository,
    required this.biometricRepository,
  }) : super(const AuthInitInitialState()) {
    on<AuthInitInitialEvent>(_onAuthInitInitial);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<SubmitEvent>(_onSubmitEvent);
    on<SubmitWithBiometricsEvent>(_onSubmitWithBiometricsEvent);
    on<CheckSupabaseBiometricsEvent>(_onCheckSupabaseBiometricsEvent);
    on<GetProfileEvent>(_onGetProfileEvent);
    on<EnrollBiometricsEvent>(_onEnrollBiometricsEvent);
  }

  FutureOr<void> _onAuthInitInitial(
    AuthInitInitialEvent event,
    Emitter<AuthInitState> emit,
  ) {
    emit(const AuthInitInitialState());
    emit(
      ChangeAuthInitState(
        state.model.copyWith(
          refreshAuth: event.refreshAuth,
        ),
      ),
    );
  }

  FutureOr<void> _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<AuthInitState> emit,
  ) {
    final password = PasswordForm.dirty(event.password);
    emit(ChangeAuthInitState(state.model.copyWith(password: password)));
  }

  FutureOr<void> _onToggleMasterPasswordEvent(
    ToggleMasterPasswordEvent event,
    Emitter<AuthInitState> emit,
  ) {
    emit(
      ChangeAuthInitState(
        state.model.copyWith(showPassword: !state.model.showPassword),
      ),
    );
  }

  FutureOr<void> _onSubmitEvent(
    SubmitEvent event,
    Emitter<AuthInitState> emit,
  ) async {
    try {
      emit(
        ChangeAuthInitState(
          state.model.copyWith(
            alreadySubmitted: true,
            status: FormzSubmissionStatus.inProgress,
          ),
        ),
      );

      if (!Formz.validate([
        state.model.password,
      ])) {
        emit(
          ChangeAuthInitState(
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

      final clearMasterPassword = state.model.password.value.trim();
      final derivedKey =
          await SecurityUtils.deriveMasterKey(clearMasterPassword, salt!, 32);
      final hashedPassword = SecurityUtils.hashMasterKey(derivedKey);
      final deviceId = await deviceInfo.getDeviceId();
      final deviceName = await deviceInfo.getDeviceName();
      final deviceType = deviceInfo.getDeviceType();
      final profileBloc = Modular.get<ProfileBloc>();

      if (deviceId == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final response = await authInitRepository.checkMasterPassword(
        inputSecret: hashedPassword,
        deviceId: deviceId,
        deviceName: deviceName,
        type: deviceType,
        biometricHash: '',
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
          if (r.data == null) {
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

          if (r.code == ApiCodes.userBlocked) {
            emit(
              UserBlockedState(
                state.model.copyWith(status: FormzSubmissionStatus.failure),
              ),
            );
            return;
          }

          if (r.code == ApiCodes.alreadyHasDeviceEnrolled ||
              r.code == ApiCodes.deviceNotEnrolled ||
              r.code == ApiCodes.success) {
            profileBloc.add(SaveDerivedKeyEvent(derivedKey: derivedKey));
            profileBloc.add(SaveJwtEvent(jwt: r.data!['jwt']));

            if (r.code == ApiCodes.alreadyHasDeviceEnrolled) {
              emit(
                DeviceAlreadyEnrolledState(
                  state.model.copyWith(status: FormzSubmissionStatus.failure),
                ),
              );
              return;
            }

            if (!hasShownEnrollBiometricsDialog &&
                !state.model.hasBiometricsSaved &&
                state.model.canAuthenticateWithBiometrics) {
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
          }
        },
      );
    } catch (e, stackTrace) {
      log.severe('Exception _onSubmitEvent: $e', e, stackTrace);
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
    }
  }

  FutureOr<void> _onSubmitWithBiometricsEvent(
    SubmitWithBiometricsEvent event,
    Emitter<AuthInitState> emit,
  ) async {
    try {
      emit(
        ChangeAuthInitState(
          state.model.copyWith(
            status: FormzSubmissionStatus.inProgress,
          ),
        ),
      );

      final isAuthenticated = await biometricUtils.authenticate();

      if (!isAuthenticated) {
        emit(
          ChangeAuthInitState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final profileBloc = Modular.get<ProfileBloc>();
      final deviceId = await deviceInfo.getDeviceId();
      final deviceName = await deviceInfo.getDeviceName();
      final deviceType = deviceInfo.getDeviceType();
      final biometricHash = await secureStorage.read(key: Env.biometricHashKey);
      final derivedKeyStored = await secureStorage.read(key: Env.derivedKey);

      if (deviceId == null ||
          biometricHash == null ||
          derivedKeyStored == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final derivedKey = base64Decode(derivedKeyStored);

      final response = await authInitRepository.checkMasterPassword(
        inputSecret: '',
        deviceId: deviceId,
        deviceName: deviceName,
        type: deviceType,
        biometricHash: biometricHash,
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

      if (data == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      if (code == ApiCodes.userBlocked) {
        emit(
          UserBlockedState(
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

      if (code == ApiCodes.alreadyHasDeviceEnrolled ||
          code == ApiCodes.success) {
        profileBloc.add(SaveDerivedKeyEvent(derivedKey: derivedKey));
        profileBloc.add(SaveJwtEvent(jwt: data!['jwt']));

        if (code == ApiCodes.alreadyHasDeviceEnrolled) {
          emit(
            DeviceAlreadyEnrolledState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
          return;
        }

        if (state.model.refreshAuth) {
          emit(
            RefreshSuccessState(
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
      }
    } catch (e, stackTrace) {
      log.severe('Exception _onSubmitEvent: $e', e, stackTrace);
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
    }
  }

  FutureOr<void> _onCheckSupabaseBiometricsEvent(
    CheckSupabaseBiometricsEvent event,
    Emitter<AuthInitState> emit,
  ) async {
    emit(
      ChangeAuthInitState(
        state.model.copyWith(
          statusBiometrics: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final deviceId = await deviceInfo.getDeviceId();

    if (deviceId == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            statusBiometrics: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final hasBiometricsSupabaseResponse =
        await authInitRepository.hasBiometrics(deviceId: deviceId);
    late final bool hasSupabaseBiometricsSaved;
    hasBiometricsSupabaseResponse.fold(
      (l) {
        hasSupabaseBiometricsSaved = false;
      },
      (r) {
        hasSupabaseBiometricsSaved = r.data?['hasBiometrics'];
      },
    );

    final hasLocalBiometricsSaved = await biometricUtils.hasBiometricsSaved();
    final canAuthenticate =
        await biometricUtils.canAuthenticateWithBiometrics();

    emit(
      ChangeAuthInitState(
        state.model.copyWith(
          hasBiometricsSaved:
              hasSupabaseBiometricsSaved && hasLocalBiometricsSaved,
          canAuthenticateWithBiometrics: canAuthenticate,
          statusBiometrics: FormzSubmissionStatus.success,
        ),
      ),
    );

    if (hasSupabaseBiometricsSaved && hasLocalBiometricsSaved && canAuthenticate) {
      emit(
        RequestBiometricsState(state.model),
      );
    }
  }

  FutureOr<void> _onGetProfileEvent(
    GetProfileEvent event,
    Emitter<AuthInitState> emit,
  ) async {
    emit(
      ChangeAuthInitState(
        state.model.copyWith(
          statusProfile: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final res = await profileRepository.getProfile();
    res.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(
              statusProfile: FormzSubmissionStatus.failure,
            ),
          ),
        );
      },
      (r) {
        emit(
          ChangeAuthInitState(
            state.model.copyWith(
              statusProfile: FormzSubmissionStatus.success,
              profile: r,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onEnrollBiometricsEvent(
    EnrollBiometricsEvent event,
    Emitter<AuthInitState> emit,
  ) async {
    try {
      await preferencesRepository.setHasShownEnrollBiometricsDialog(true);

      emit(
        ChangeAuthInitState(
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

      final clearMasterPassword = state.model.password.value.trim();
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
