import 'package:dartz/dartz.dart';
import 'package:savepass/app/password/domain/datasources/password_datasource.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordDatasource datasource;

  PasswordRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, SavePassResponseModel>> insertPassword({
    required PasswordModel model,
  }) async {
    return await datasource.insertPassword(model: model);
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> editPassword({
    required PasswordModel model,
  }) async {
    return await datasource.editPassword(model: model);
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> deletePassword({
    required String passwordId,
    required String vaultId,
  }) async {
    return await datasource.deletePassword(
      passwordId: passwordId,
      vaultId: vaultId,
    );
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getPasswords() async {
    return await datasource.getPasswords();
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getPasswordById({
    required String passwordId,
  }) async {
    return await datasource.getPasswordById(
      passwordId: passwordId,
    );
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> searchPasswords({
    required String search,
  }) async {
    return await datasource.searchPasswords(
      search: search,
    );
  }
}
