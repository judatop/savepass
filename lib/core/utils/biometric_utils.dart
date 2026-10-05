import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/utils/device_info.dart';

class BiometricUtils {
  final LocalAuthentication localAuth;
  final Logger log;
  final DeviceInfo deviceInfo;
  final FlutterSecureStorage secureStorage;

  const BiometricUtils({
    required this.localAuth,
    required this.log,
    required this.deviceInfo,
    required this.secureStorage,
  });

  Future<bool> canAuthenticateWithBiometrics() async {
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    final availableBiometrics = await localAuth.getAvailableBiometrics();
    final isPhysicalDevice = await deviceInfo.isPhysicalDevice();

    return canCheckBiometrics &&
        availableBiometrics.isNotEmpty &&
        isPhysicalDevice;
  }

  Future<bool> hasBiometricsSaved() async {
    final val = await secureStorage.read(key: Env.biometricHashKey);
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
    await secureStorage.write(key: 'biometrics', value: true.toString());
    return true;
  }
}
