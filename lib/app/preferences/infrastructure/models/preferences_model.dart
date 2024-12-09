import 'package:equatable/equatable.dart';
import 'package:savepass/app/preferences/domain/entities/preferences_entity.dart';

class PreferencesModel extends PreferencesEntity with EquatableMixin {
  PreferencesModel({
    required super.brightness,
  });

  PreferencesModel copyWith({
    BrightnessType? brightness,
  }) {
    return PreferencesModel(
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  List<Object?> get props => [
        brightness,
      ];
}
