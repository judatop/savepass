import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:savepass/app/theme/domain/entities/theme_entity.dart';
import 'package:savepass/app/theme/domain/repositories/theme_repository.dart';
import 'package:savepass/app/theme/infrastructure/models/theme_model.dart';
import 'package:savepass/core/storage/storage_preferences.dart';

class ThemeIRepository implements ThemeRepository {
  final storage = Modular.get<FlutterSecureStorage>();

  @override
  Future<Either<Fail, ThemeModel>> getTheme() async {
    try {
      final brightnessValue =
          await storage.read(key: StoragePreferences.brightnessKey);

      return Right(
        ThemeModel(
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
  Future<Either<Fail, ThemeModel>> setTheme(BrightnessType brightness) async {
    try {
      await storage.write(
        key: StoragePreferences.brightnessKey,
        value: brightness.toString(),
      );

      return Right(ThemeModel(brightness: brightness));
    } catch (e) {
      return Left(Fail('Error setting theme'));
    }
  }
}
