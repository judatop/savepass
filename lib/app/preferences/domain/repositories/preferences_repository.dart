import 'package:dartz/dartz.dart';
import 'package:savepass/app/preferences/domain/entities/preferences_entity.dart';
import 'package:savepass/app/preferences/infrastructure/models/card_image_model.dart';
import 'package:savepass/app/preferences/infrastructure/models/pass_image_model.dart';
import 'package:savepass/app/preferences/infrastructure/models/preferences_model.dart';

abstract class PreferencesRepository {
  Future<Either<Fail, PreferencesModel>> getTheme();
  Future<Either<Fail, PreferencesModel>> setTheme(BrightnessType brightness);
  Future<Either<Fail, String?>> getLanguage();
  Future<Either<Fail, String>> setLanguage(String language);
  Future<Either<Fail, String>> getPrivacyUrl();
  Future<Either<Fail, String>> getTermsUrl();
  Future<Either<Fail, List<PassImageModel>>> getPassImages();
  Future<Either<Fail, List<CardImageModel>>> getCardImages();


}
