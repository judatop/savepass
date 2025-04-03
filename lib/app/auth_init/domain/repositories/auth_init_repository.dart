import 'package:dartz/dartz.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

abstract class AuthInitRepository {
  Future<Either<Fail, SavePassResponseModel>> checkMasterPassword({
    required String inputSecret,
    required String deviceId,
    required String biometricHash,
  });

  Future<Either<Fail, SavePassResponseModel>> getUserSalt();

  Future<Either<Fail, SavePassResponseModel>> hasBiometrics({
    required String deviceId,
  });
}
