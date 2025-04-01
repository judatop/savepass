import 'package:dartz/dartz.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

abstract class BiometricDatasource {
  Future<Either<Fail, SavePassResponseModel>> enrollBiometric({
    required String inputSecret,
    required String deviceId,
  });
}
