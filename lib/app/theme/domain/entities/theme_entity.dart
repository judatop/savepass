class ThemeEntity {
  final BrightnessType brightness;

  ThemeEntity({
    required this.brightness,
  });
}

enum BrightnessType { light, dark }
