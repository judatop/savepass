import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_event.dart';
import 'package:savepass/app/splash/presentation/blocs/splash_state.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/main.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final ProfileRepository profileRepository;
  final PreferencesRepository preferencesRepository;
  final Logger log;

  SplashBloc({
    required this.log,
    required this.profileRepository,
    required this.preferencesRepository,
  }) : super(const SplashInitialState()) {
    on<SplashInitialEvent>(_onSplashInitial);
    on<ManageRouteChangeEvent>(_onManageRouteChangeEvent);
    on<CheckAppVersionAndFeatureFlagEvent>(
      _onCheckAppVersionAndFeatureFlagEvent,
    );
  }

  FutureOr<void> _onSplashInitial(
    SplashInitialEvent event,
    Emitter<SplashState> emit,
  ) {
    emit(const SplashInitialState());
  }

  FutureOr<void> _onManageRouteChangeEvent(
    ManageRouteChangeEvent event,
    Emitter<SplashState> emit,
  ) async {
    final user = supabase.auth.currentUser;
    final session = supabase.auth.currentSession;

    if (user == null ||
        session == null ||
        user.aud != 'authenticated' ||
        session.isExpired) {
      emit(OpenGetStartedState(state.model));
      return;
    }

    final checkMasterPasswordResponse =
        await profileRepository.checkIfHasMasterPassword();

    late bool? hasMasterPassword;
    checkMasterPasswordResponse.fold(
      (l) {
        hasMasterPassword = null;
      },
      (r) {
        hasMasterPassword = r.data?['result'];
      },
    );

    if (hasMasterPassword == null) {
      emit(
        OpenGetStartedState(
          state.model,
        ),
      );
      return;
    }

    if (hasMasterPassword!) {
      emit(
        OpenAuthInitState(
          state.model,
        ),
      );

      return;
    }

    emit(
      OpenSyncMasterPasswordState(
        state.model,
      ),
    );
  }

  Future<void> _onCheckAppVersionAndFeatureFlagEvent(
    CheckAppVersionAndFeatureFlagEvent event,
    Emitter<SplashState> emit,
  ) async {
    _checkFeatureFlag();
    _checkAppVersion();
  }

  Future<void> _checkFeatureFlag() async {
    bool success = false;

    while (!success) {
      final response = await preferencesRepository.getFeatureFlag();

      if (response.isLeft()) {
        await Future.delayed(const Duration(seconds: 3));
        continue;
      }

      final featureFlag = response.getOrElse(() => '');

      if (featureFlag.isEmpty) {
        await Future.delayed(const Duration(seconds: 3));
        continue;
      }

      if (featureFlag == '0') {
        Modular.to.pushNamedAndRemoveUntil(
          Routes.weAreExperiencingIssuesRoute,
          (_) => false,
        );
        break;
      }

      success = true;
    }
  }

  Future<void> _checkAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final currentAppVersion = packageInfo.version;

    bool success = false;

    while (!success) {
      final response = await preferencesRepository.getAppVersion();

      if (response.isLeft()) {
        await Future.delayed(const Duration(seconds: 3));
        continue;
      }

      final appVersion = response.getOrElse(() => '');

      if (appVersion.isEmpty) {
        await Future.delayed(const Duration(seconds: 3));
        continue;
      }

      if (appVersion != currentAppVersion) {
        Modular.to.pushNamedAndRemoveUntil(
          Routes.newAppVersionRoute,
          (_) => false,
        );
        break;
      }

      success = true;
    }
  }
}
