import 'package:dartz/dartz.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

abstract class PasswordRepository {
  Future<Either<Fail, SavePassResponseModel>> insertPassword({
    required PasswordModel model,
  });

  Future<Either<Fail, SavePassResponseModel>> editPassword({
    required PasswordModel model,
  });

  Future<Either<Fail, SavePassResponseModel>> deletePassword({
    required String passwordId,
    required String vaultId,
  });

  Future<Either<Fail, SavePassResponseModel>> getPasswords();

  Future<Either<Fail, SavePassResponseModel>> getPasswordById({
    required String passwordId,
  });

  Future<Either<Fail, SavePassResponseModel>> searchPasswords({
    required String search,
  });
}
