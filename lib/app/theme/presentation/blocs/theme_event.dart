import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class GetThemeEvent extends ThemeEvent {
  const GetThemeEvent() : super();
}

class ToggleBrightnessEvent extends ThemeEvent {
  const ToggleBrightnessEvent() : super();
}
