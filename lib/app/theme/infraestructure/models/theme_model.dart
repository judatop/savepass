import 'package:equatable/equatable.dart';
import 'package:savepass/app/theme/domain/entities/theme_entity.dart';

class ThemeModel extends ThemeEntity with EquatableMixin {
  ThemeModel({
    required super.brightness,
  });

  ThemeModel copyWith({
    BrightnessType? brightness,
  }) {
    return ThemeModel(
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  List<Object?> get props => [
        brightness,
      ];
}
