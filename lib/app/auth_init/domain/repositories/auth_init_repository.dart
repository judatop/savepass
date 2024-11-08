import 'package:dartz/dartz.dart';

abstract class AuthInitRepository {
  Future<Either<Fail, bool>> checkMasterPassword({
    required String secretUuid,
    required String inputPassword,
  });
}
