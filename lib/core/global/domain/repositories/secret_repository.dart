import 'package:dartz/dartz.dart';

abstract class SecretRepository {
  Future<Either<Fail, String>> addSecret({
    required String secret,
    required String name,
  });

  Future<Either<Fail, String>> getSecret({
    required String secretUuid,
  });
}
