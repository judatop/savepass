import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_event.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_state.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_event.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/utils/biometric_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/security_utils.dart';

class AuthInitBloc extends Bloc<AuthInitEvent, AuthInitState> {
  final ProfileRepository profileRepository;
  final AuthInitRepository authInitRepository;
  final BiometricUtils biometricUtils;

  AuthInitBloc({
    required this.profileRepository,
    required this.authInitRepository,
    required this.biometricUtils,
  }) : super(const AuthInitInitialState()) {
    on<AuthInitInitialEvent>(_onAuthInitInitial);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<SubmitEvent>(_onSubmitEvent);
  }

  FutureOr<void> _onAuthInitInitial(
    AuthInitInitialEvent event,
    Emitter<AuthInitState> emit,
  ) async {
    emit(const AuthInitInitialState());

    final res = await profileRepository.getProfile();
    res.fold(
      (l) {},
      (r) {
        emit(
          ChangeAuthInitState(
            state.model.copyWith(
              profile: r,
            ),
          ),
        );
      },
    );

    final hasBiometrics = await biometricUtils.hasBiometricsSaved();
    final canAuthenticate =
        await biometricUtils.canAuthenticateWithBiometrics();

    emit(
      ChangeAuthInitState(
        state.model.copyWith(
          hasBiometricsSaved: hasBiometrics,
          canAuthenticateWithBiometrics: canAuthenticate,
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
        SecurityUtils.deriveMasterKey(clearMasterPassword, salt!, 32);
    final hashedPassword = SecurityUtils.hashMasterKey(derivedKey);
    final deviceId = await DeviceInfo.getDeviceId();
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
  }
}
