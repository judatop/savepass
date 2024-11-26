import 'package:dartz/dartz.dart';
import 'package:savepass/app/auth_init/domain/datasources/auth_init_datasource.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';

class AuthInitRepositoryImpl implements AuthInitRepository {
  final AuthInitDatasource datasource;

  AuthInitRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, bool>> checkMasterPassword({
    required String inputPassword,
  }) async {
    return await datasource.checkMasterPassword(
      inputPassword: inputPassword,
    );
  }
}
