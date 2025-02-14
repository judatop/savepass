import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricUtils {
  static LocalAuthentication auth = LocalAuthentication();

  static Future<bool> canAuthenticateWithBiometrics() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  static Future<bool> hasBiometricsSaved() async {
    AndroidOptions androidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: androidOptions());
    final val = await storage.read(key: 'biometrics');
    return val != null;
  }

  static Future<bool> authenticate() async {
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.isEmpty) {
      throw Exception('Register biometrics');
    }

    final bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Please authenticate to show account balance',
      options: const AuthenticationOptions(biometricOnly: true),
    );

    return didAuthenticate;
  }

  static Future<bool> saveBiometrics() async {
    AndroidOptions androidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: androidOptions());
    await storage.write(key: 'biometrics', value: true.toString());
    return true;
  }
}
