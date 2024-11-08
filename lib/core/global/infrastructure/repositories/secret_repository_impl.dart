import 'package:dartz/dartz.dart';
import 'package:savepass/core/global/domain/datasources/secret_datasource.dart';
import 'package:savepass/core/global/domain/repositories/secret_repository.dart';

class SecretRepositoryImpl implements SecretRepository {
  final SecretDatasource datasource;

  SecretRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, String>> addSecret({
    required String secret,
    required String name,
  }) async {
    return await datasource.addSecret(secret: secret, name: name);
  }

  @override
  Future<Either<Fail, String>> getSecret({required String secretUuid}) async {
    return await datasource.getSecret(secretUuid: secretUuid);
  }
}
