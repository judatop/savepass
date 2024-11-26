import 'package:dartz/dartz.dart';

abstract class AuthInitDatasource {
  Future<Either<Fail, bool>> checkMasterPassword({
    required String inputPassword,
  });
}
