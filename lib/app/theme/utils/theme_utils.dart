import 'package:savepass/app/theme/domain/entities/theme_entity.dart';
import 'package:savepass/app/theme/infrastructure/models/theme_model.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_state.dart';

class ThemeUtils {
  static final defaultAccountPreferencesModel = ThemeStateModel(
    theme: ThemeModel(
      brightness: BrightnessType.dark,
    ),
  );
}
