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
}
