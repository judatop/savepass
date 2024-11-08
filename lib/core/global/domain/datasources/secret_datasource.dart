import 'package:dartz/dartz.dart';

abstract class SecretDatasource {
  Future<Either<Fail, String>> addSecret({
    required String secret,
    required String name,
  });

  Future<Either<Fail, String>> getSecret({
    required String secretUuid,
  });
}
