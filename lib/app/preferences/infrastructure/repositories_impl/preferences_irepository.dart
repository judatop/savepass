import 'package:dartz/dartz.dart';
import 'package:savepass/app/preferences/domain/datasources/parameters_datasource.dart';
import 'package:savepass/app/preferences/domain/datasources/preferences_datasource.dart';
import 'package:savepass/app/preferences/domain/entities/preferences_entity.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/infrastructure/models/card_image_model.dart';
import 'package:savepass/app/preferences/infrastructure/models/pass_image_model.dart';
import 'package:savepass/app/preferences/infrastructure/models/preferences_model.dart';

class PreferencesIRepository implements PreferencesRepository {
  final PreferencesDatasource localDatasource;
  final ParametersDatasource supabaseDatasource;

  PreferencesIRepository({
    required this.localDatasource,
    required this.supabaseDatasource,
  });

  @override
  Future<Either<Fail, String?>> getLanguage() async {
    return await localDatasource.getLanguage();
  }

  @override
  Future<Either<Fail, PreferencesModel>> getTheme() async {
    return await localDatasource.getTheme();
  }

  @override
  Future<Either<Fail, String>> setLanguage(String language) async {
    return await localDatasource.setLanguage(language);
  }

  @override
  Future<Either<Fail, PreferencesModel>> setTheme(
    BrightnessType brightness,
  ) async {
    return await localDatasource.setTheme(brightness);
  }

  @override
  Future<Either<Fail, String>> getPrivacyUrl() async {
    return await supabaseDatasource.getPrivacyUrl();
  }

  @override
  Future<Either<Fail, String>> getTermsUrl() async {
    return await supabaseDatasource.getTermsUrl();
  }

  @override
  Future<Either<Fail, List<PassImageModel>>> getPassImages() async {
    return await supabaseDatasource.getPassImages();
  }

  @override
  Future<Either<Fail, List<CardImageModel>>> getCardImages() async {
    return await supabaseDatasource.getCardImages();
  }

  @override
  Future<Either<Fail, String>> getAppVersion() async {
    return await supabaseDatasource.getAppVersion();
  }

  @override
  Future<Either<Fail, String>> getFeatureFlag() async {
    return await supabaseDatasource.getFeatureFlag();
  }

  @override
  Future<Either<Fail, String>> getAppStoreURL() async {
    return await supabaseDatasource.getAppStoreURL();
  }

  @override
  Future<Either<Fail, String>> getPlayStoreURL() async {
    return await supabaseDatasource.getPlayStoreURL();
  }

  @override
  Future<Either<Fail, String>> getSavePassDocsURL() async {
    return await supabaseDatasource.getSavePassDocsURL();
  }

  @override
  Future<Either<Fail, String>> getSupportMail() async {
    return await supabaseDatasource.getSupportMail();
  }
}
