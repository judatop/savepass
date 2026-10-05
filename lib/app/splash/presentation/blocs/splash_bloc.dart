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
import 'package:savepass/core/utils/session_utils.dart';
import 'package:savepass/core/utils/version_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:savepass/main.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /// Retried, but bounded: neither call is awaited, so an unbounded loop stays
  /// alive after the user has moved on and can navigate from underneath them.
  static const _maxCheckAttempts = 4;
  static const _checkRetryDelay = Duration(seconds: 3);

  final ProfileRepository profileRepository;
  final PreferencesRepository preferencesRepository;
  final SessionUtils sessionUtils;
  final Logger log;

  SplashBloc({
    required this.log,
    required this.profileRepository,
    required this.preferencesRepository,
    required this.sessionUtils,
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
    // Only a verdict from the server ends the session; a transport failure
    // falls through to the local checks below.
    try {
      final userResponse = await supabase.auth.getUser();

      if (userResponse.user == null) {
        await sessionUtils.clearLocalSession();
        emit(OpenGetStartedState(state.model));
        return;
      }
    } on AuthRetryableFetchException catch (e, stackTrace) {
      // Extends AuthException, so it MUST be caught first: it means the request
      // never got an answer, not that the token was rejected.
      log.warning('getUser unreachable, keeping session: $e', e, stackTrace);
    } on AuthException catch (e, stackTrace) {
      log.info('getUser rejected the session: $e', e, stackTrace);
      await sessionUtils.clearLocalSession();
      emit(OpenGetStartedState(state.model));
      return;
    } catch (e, stackTrace) {
      log.warning('getUser failed, keeping session: $e', e, stackTrace);
    }

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
    for (var attempt = 0; attempt < _maxCheckAttempts; attempt++) {
      if (attempt > 0) {
        await Future.delayed(_checkRetryDelay * attempt);
      }

      final response = await preferencesRepository.getFeatureFlag();

      if (response.isLeft()) {
        continue;
      }

      final featureFlag = response.getOrElse(() => '');

      if (featureFlag.isEmpty) {
        continue;
      }

      if (featureFlag == '0') {
        Modular.to.pushNamedAndRemoveUntil(
          Routes.weAreExperiencingIssuesRoute,
          (_) => false,
        );
      }

      return;
    }

    log.warning('Feature flag unavailable after $_maxCheckAttempts attempts');
  }

  Future<void> _checkAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentAppVersion = packageInfo.version;

    for (var attempt = 0; attempt < _maxCheckAttempts; attempt++) {
      if (attempt > 0) {
        await Future.delayed(_checkRetryDelay * attempt);
      }

      final response = await preferencesRepository.getAppVersion();

      if (response.isLeft()) {
        continue;
      }

      final appVersion = response.getOrElse(() => '');

      if (appVersion.isEmpty) {
        continue;
      }

      if (VersionUtils.isOlderThan(currentAppVersion, appVersion)) {
        Modular.to.pushNamedAndRemoveUntil(
          Routes.newAppVersionRoute,
          (_) => false,
        );
      }

      return;
    }

    log.warning('App version unavailable after $_maxCheckAttempts attempts');
  }
}
