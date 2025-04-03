import 'package:savepass/app/preferences/domain/entities/preferences_entity.dart';
import 'package:savepass/app/preferences/infrastructure/models/preferences_model.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_state.dart';

class PreferencesUtils {
  static const defaultAccountPreferencesModel = ThemeStateModel(
    theme: PreferencesModel(
      brightness: BrightnessType.dark,
    ),
  );

  static String getLanguageText(String language) {
    switch (language) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }

  static String getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'Español':
        return 'es';
      default:
        return 'en';
    }
  }

}
