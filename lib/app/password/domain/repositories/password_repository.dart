import 'package:dartz/dartz.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';

abstract class PasswordRepository {
  Future<Either<Fail, Unit>> insertPassword(PasswordModel model);
  Future<Either<Fail, List<PasswordModel>>> getPasswords();
  Future<Either<Fail, String>> getPassword(String passwordId);
  Future<Either<Fail, PasswordModel>> getPasswordModel(String passwordId);
  Future<Either<Fail, Unit>> editPassword(PasswordModel model, String clearPassword);
  Future<Either<Fail, Unit>> deletePassword(String passwordId, String vaultId);

}
