import 'package:dartz/dartz.dart';
import 'package:savepass/app/auth_init/domain/datasources/auth_init_datasource.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

class AuthInitRepositoryImpl implements AuthInitRepository {
  final AuthInitDatasource datasource;

  AuthInitRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, SavePassResponseModel>> checkMasterPassword({
    required String inputSecret,
    required String deviceId,
    required String biometricHash,
  }) async {
    return await datasource.checkMasterPassword(
      inputSecret: inputSecret,
      deviceId: deviceId,
      biometricHash: biometricHash,
    );
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getUserSalt() async {
    return await datasource.getUserSalt();
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> hasBiometrics({
    required String deviceId,
  }) async {
    return await datasource.hasBiometrics(deviceId: deviceId);
  }
}
