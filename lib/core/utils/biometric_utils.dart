import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';
import 'package:savepass/core/env/env.dart';

class BiometricUtils {
  final LocalAuthentication localAuth;
  final Logger log;

  const BiometricUtils({
    required this.localAuth,
    required this.log,
  });

  Future<bool> canAuthenticateWithBiometrics() async {
    final bool canAuthenticateWithBiometrics =
        await localAuth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> hasBiometricsSaved() async {
    AndroidOptions androidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: androidOptions());
    final val = await storage.read(key: Env.biometricHashKey);
    return val != null;
  }

  Future<bool> authenticate() async {
    bool isAuthenticated = false;

    try {
      final List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        throw Exception('Register biometrics');
      }

      isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e, stackTrace) {
      log.severe('Biometric utils authenticate error: $e', e, stackTrace);
    }

    return isAuthenticated;
  }

  Future<bool> saveBiometrics() async {
    AndroidOptions androidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: androidOptions());
    await storage.write(key: 'biometrics', value: true.toString());
    return true;
  }
}
