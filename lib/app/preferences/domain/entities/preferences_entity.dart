class PreferencesEntity {
  final BrightnessType brightness;

  const PreferencesEntity({
    required this.brightness,
  });
}

enum BrightnessType { system, light, dark }
