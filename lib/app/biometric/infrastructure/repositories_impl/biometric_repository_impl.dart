import 'package:dartz/dartz.dart';
import 'package:savepass/app/biometric/domain/datasources/biometric_datasource.dart';
import 'package:savepass/app/biometric/domain/repositories/biometric_repository.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

class BiometricRepositoryImpl implements BiometricRepository {
  final BiometricDatasource datasource;

  BiometricRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, SavePassResponseModel>> enrollBiometric({
    required String inputSecret,
    required String deviceId,
  }) async {
    return await datasource.enrollBiometric(
      inputSecret: inputSecret,
      deviceId: deviceId,
    );
  }
}
