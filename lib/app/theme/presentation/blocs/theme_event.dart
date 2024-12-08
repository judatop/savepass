import 'package:equatable/equatable.dart';
import 'package:savepass/app/theme/domain/entities/theme_entity.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class GetThemeEvent extends ThemeEvent {
  const GetThemeEvent() : super();
}

class ToggleBrightnessEvent extends ThemeEvent {
  final BrightnessType brightness;

  const ToggleBrightnessEvent({required this.brightness}) : super();
}
