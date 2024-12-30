import 'package:dartz/dartz.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';

abstract class PasswordDatasource {
  Future<Either<Fail, Unit>> insertPassword(PasswordModel model);
}
