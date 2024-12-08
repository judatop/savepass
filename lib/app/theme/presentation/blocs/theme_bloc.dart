import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/theme/domain/repositories/theme_repository.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_event.dart';
import 'package:savepass/app/theme/presentation/blocs/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository repository;

  ThemeBloc(this.repository) : super(ThemeInitialState()) {
    on<GetThemeEvent>(_onGetThemeEvent);
    on<ToggleBrightnessEvent>(onToggleBrightness);
  }

  FutureOr<void> onToggleBrightness(
    ToggleBrightnessEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final theme = await repository.setTheme(event.brightness);

    theme.fold(
      (fail) => emit(ThemeInitialState()),
      (themeModel) => emit(
        ChangeThemeState(
          ThemeStateModel(
            theme: themeModel,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onGetThemeEvent(
    GetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final theme = await repository.getTheme();

    theme.fold(
      (fail) => emit(ThemeInitialState()),
      (themeModel) => emit(
        ChangeThemeState(
          ThemeStateModel(
            theme: themeModel,
          ),
        ),
      ),
    );
  }
}
