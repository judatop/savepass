import 'package:dartz/dartz.dart';
import 'package:savepass/app/preferences/infrastructure/models/card_image_model.dart';
import 'package:savepass/app/preferences/infrastructure/models/pass_image_model.dart';

abstract class ParametersDatasource {
  Future<Either<Fail, String>> getPrivacyUrl();
  Future<Either<Fail, String>> getTermsUrl();
  Future<Either<Fail, List<PassImageModel>>> getPassImages();
  Future<Either<Fail, List<CardImageModel>>> getCardImages();
}
