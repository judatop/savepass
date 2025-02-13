import 'package:local_auth/local_auth.dart';

class BiometricUtils {
  static LocalAuthentication auth = LocalAuthentication();

  static Future<bool> canAuthenticateWithBiometrics() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
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
}
