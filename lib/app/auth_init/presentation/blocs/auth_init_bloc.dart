import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_event.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_state.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_event.dart';
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

  AuthInitBloc({
    required this.profileRepository,
    required this.authInitRepository,
    required this.biometricUtils,
    required this.log,
    required this.secureStorage,
    required this.deviceInfo,
  }) : super(const AuthInitInitialState()) {
    on<AuthInitInitialEvent>(_onAuthInitInitial);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<SubmitEvent>(_onSubmitEvent);
    on<SubmitWithBiometricsEvent>(_onSubmitWithBiometricsEvent);
    on<CheckSupabaseBiometricsEvent>(_onCheckSupabaseBiometricsEvent);
    on<GetProfileEvent>(_onGetProfileEvent);
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

      final clearMasterPassword = state.model.password.value;
      final derivedKey =
          await SecurityUtils.deriveMasterKey(clearMasterPassword, salt!, 32);
      final hashedPassword = SecurityUtils.hashMasterKey(derivedKey);
      final deviceId = await deviceInfo.getDeviceId();
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

            emit(
              OpenHomeState(
                state.model.copyWith(status: FormzSubmissionStatus.success),
              ),
            );
          }
        },
      );
    } catch (e) {
      log.e('Exception _onSubmitEvent: $e');
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
      AndroidOptions androidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      final storage = FlutterSecureStorage(aOptions: androidOptions());
      final biometricHash = await storage.read(key: Env.biometricHashKey);

      final derivedKeyStored = await storage.read(key: Env.derivedKey);

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
    } catch (e) {
      log.e('Exception _onSubmitEvent: $e');
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
}
