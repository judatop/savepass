import 'package:dartz/dartz.dart';

abstract class ParametersDatasource {
  Future<Either<Fail, String>> getPrivacyUrl();
  Future<Either<Fail, String>> getTermsUrl();
}
