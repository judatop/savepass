import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/biometric/domain/repositories/biometric_repository.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/utils/biometric_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/security_utils.dart';

enum BiometricEnrollmentResult {
  enrolled,
  notAuthenticated,
  invalidMasterPassword,
  failed,
}

/// Enrolls biometric unlock for the current device, shared by `auth_init_bloc`
/// and `sync_bloc`.
class BiometricEnrollmentService {
  final BiometricUtils biometricUtils;
  final AuthInitRepository authInitRepository;
  final BiometricRepository biometricRepository;
  final FlutterSecureStorage secureStorage;
  final DeviceInfo deviceInfo;
  final Logger log;

  const BiometricEnrollmentService({
    required this.biometricUtils,
    required this.authInitRepository,
    required this.biometricRepository,
    required this.secureStorage,
    required this.deviceInfo,
    required this.log,
  });

  Future<BiometricEnrollmentResult> enroll({
    required String masterPassword,
  }) async {
    try {
      final isAuthenticated = await biometricUtils.authenticate();

      if (!isAuthenticated) {
        return BiometricEnrollmentResult.notAuthenticated;
      }

      final saltResponse = await authInitRepository.getUserSalt();
      late String? salt;
      saltResponse.fold(
        (l) => salt = null,
        (r) => salt = r.data?['salt'],
      );

      if (salt == null) {
        log.severe('enroll: user salt is null');
        return BiometricEnrollmentResult.failed;
      }

      final deviceId = await deviceInfo.getDeviceId();

      if (deviceId == null) {
        log.severe('enroll: device id is null');
        return BiometricEnrollmentResult.failed;
      }

      final derivedKey = await SecurityUtils.deriveMasterKey(
        masterPassword.trim(),
        salt!,
        32,
      );
      final hashedPassword = SecurityUtils.hashMasterKey(derivedKey);

      final response = await biometricRepository.enrollBiometric(
        inputSecret: hashedPassword,
        deviceId: deviceId,
      );

      late final String? code;
      late final Map<String, dynamic>? data;
      response.fold(
        (l) => code = null,
        (r) {
          code = r.code;
          data = r.data;
        },
      );

      if (code == ApiCodes.invalidMasterPassword) {
        return BiometricEnrollmentResult.invalidMasterPassword;
      }

      if (code != ApiCodes.success || data == null) {
        log.severe('enroll: backend returned $code');
        return BiometricEnrollmentResult.failed;
      }

      await secureStorage.write(
        key: Env.biometricHashKey,
        value: data!['hash'],
      );
      await secureStorage.write(
        key: Env.derivedKey,
        value: base64Encode(derivedKey),
      );

      return BiometricEnrollmentResult.enrolled;
    } catch (e, stackTrace) {
      log.severe('enroll: $e', e, stackTrace);
      return BiometricEnrollmentResult.failed;
    }
  }
}
