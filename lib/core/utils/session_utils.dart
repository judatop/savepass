import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_event.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/storage/storage_preferences.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/main.dart';

/// Single definition of what ending a session means. Every sign out goes
/// through here; a bare `supabase.auth.signOut()` leaves the previous
/// account's secrets on the device and in [ProfileBloc].
class SessionUtils {
  final FlutterSecureStorage secureStorage;
  final ProfileRepository profileRepository;
  final DeviceInfo deviceInfo;
  final Logger log;

  const SessionUtils({
    required this.secureStorage,
    required this.profileRepository,
    required this.deviceInfo,
    required this.log,
  });

  /// Theme and language deliberately survive: they are not secrets.
  static const _userScopedKeys = <String>[
    StoragePreferences.hasShownEnrollBiometricsDialogKey,
  ];

  /// Ends the session on the backend first, then locally. Returns false and
  /// changes nothing if the backend could not be reached.
  ///
  /// The order matters: the RPC needs the Supabase session and the JWT held by
  /// [ProfileBloc], so clearing those first would leave the `sessions` row
  /// active forever, consuming one of the account's allowed devices.
  Future<bool> closeSession() async {
    final deviceId = await deviceInfo.getDeviceId();

    if (deviceId == null) {
      log.severe('closeSession: device id is null');
      return false;
    }

    final response = await profileRepository.closeSession(deviceId: deviceId);

    late final String? code;
    response.fold(
      (l) => code = null,
      (r) => code = r.code,
    );

    if (code != ApiCodes.success) {
      log.severe('closeSession: backend returned $code');
      return false;
    }

    for (final key in [
      Env.derivedKey,
      Env.biometricHashKey,
      ..._userScopedKeys,
    ]) {
      await secureStorage.delete(key: key);
    }

    Modular.get<ProfileBloc>().add(const ClearValuesEvent());
    await supabase.auth.signOut();

    return true;
  }

  /// Clears the device without touching the backend, for the paths where there
  /// is no session left to close.
  Future<void> clearLocalSession() async {
    try {
      for (final key in [
        Env.derivedKey,
        Env.biometricHashKey,
        ..._userScopedKeys,
      ]) {
        await secureStorage.delete(key: key);
      }

      Modular.get<ProfileBloc>().add(const ClearValuesEvent());
    } catch (e, stackTrace) {
      log.severe('clearLocalSession cleanup failed: $e', e, stackTrace);
    } finally {
      await supabase.auth.signOut();
    }
  }
}
