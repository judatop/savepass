class PreferencesEntity {
  final BrightnessType brightness;

  PreferencesEntity({
    required this.brightness,
  });
}

enum BrightnessType { system, light, dark }
