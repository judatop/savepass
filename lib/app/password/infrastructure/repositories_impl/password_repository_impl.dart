import 'package:dartz/dartz.dart';
import 'package:savepass/app/password/domain/datasources/password_datasource.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordDatasource datasource;

  PasswordRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, Unit>> insertPassword(PasswordModel model) async {
    return await datasource.insertPassword(model);
  }

  @override
  Future<Either<Fail, List<PasswordModel>>> getPasswords() async {
    return await datasource.getPasswords();
  }

  @override
  Future<Either<Fail, String>> getPassword(String passwordId) async {
    return await datasource.getPassword(passwordId);
  }

  @override
  Future<Either<Fail, PasswordModel>> getPasswordModel(
    String passwordId,
  ) async {
    return await datasource.getPasswordModel(passwordId);
  }

  @override
  Future<Either<Fail, Unit>> editPassword(
    PasswordModel model,
    String clearPassword,
  ) async {
    return await datasource.editPassword(model, clearPassword);
  }

  @override
  Future<Either<Fail, Unit>> deletePassword(
    String passwordId,
    String vaultId,
  ) async {
    return await datasource.deletePassword(passwordId, vaultId);
  }

  @override
  Future<Either<Fail, List<PasswordModel>>> searchPasswords(
      String search) async {
    return await datasource.searchPasswords(search);
  }
}
