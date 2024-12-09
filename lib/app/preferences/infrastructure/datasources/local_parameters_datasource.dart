import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savepass/app/preferences/domain/datasources/preferences_datasource.dart';
import 'package:savepass/app/preferences/domain/entities/preferences_entity.dart';
import 'package:savepass/app/preferences/infrastructure/models/preferences_model.dart';
import 'package:savepass/core/storage/storage_preferences.dart';

class LocalPreferencesDatasource implements PreferencesDatasource {
  final FlutterSecureStorage storage;

  LocalPreferencesDatasource({required this.storage});

  @override
  Future<Either<Fail, PreferencesModel>> getTheme() async {
    try {
      final brightnessValue =
          await storage.read(key: StoragePreferences.brightnessKey);

      return Right(
        PreferencesModel(
          brightness: brightnessValue == BrightnessType.light.toString()
              ? BrightnessType.light
              : brightnessValue == BrightnessType.dark.toString()
                  ? BrightnessType.dark
                  : BrightnessType.system,
        ),
      );
    } catch (e) {
      return Left(Fail('Error getting theme'));
    }
  }

  @override
  Future<Either<Fail, PreferencesModel>> setTheme(
    BrightnessType brightness,
  ) async {
    try {
      await storage.write(
        key: StoragePreferences.brightnessKey,
        value: brightness.toString(),
      );

      return Right(PreferencesModel(brightness: brightness));
    } catch (e) {
      return Left(Fail('Error setting theme'));
    }
  }

  @override
  Future<Either<Fail, String?>> getLanguage() async {
    try {
      final languageValue =
          await storage.read(key: StoragePreferences.languageKey);

      return Right(languageValue);
    } catch (e) {
      return Left(Fail('Error getting language'));
    }
  }

  @override
  Future<Either<Fail, String>> setLanguage(String language) async {
    try {
      await storage.write(
        key: StoragePreferences.languageKey,
        value: language,
      );

      return Right(language);
    } catch (e) {
      return Left(Fail('Error setting language'));
    }
  }
}
