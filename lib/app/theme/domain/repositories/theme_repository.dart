import 'package:dartz/dartz.dart';
import 'package:savepass/app/theme/domain/entities/theme_entity.dart';
import 'package:savepass/app/theme/infrastructure/models/theme_model.dart';

abstract class ThemeRepository {
  Future<Either<Fail, ThemeModel>> getTheme();
  Future<Either<Fail, ThemeModel>> setTheme(BrightnessType brightness);
}
