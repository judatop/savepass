import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_event.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository repository;

  PreferencesBloc(this.repository) : super(ThemeInitialState()) {
    on<GetThemeEvent>(_onGetThemeEvent);
    on<ToggleBrightnessEvent>(onToggleBrightness);
    on<ChangeLocaleEvent>(_onChangeLocaleEvent);
    on<GetLanguageEvent>(_onGetLanguageEvent);
    on<GetAppVersion>(_onGetAppVersion);
  }

  FutureOr<void> onToggleBrightness(
    ToggleBrightnessEvent event,
    Emitter<PreferencesState> emit,
  ) async {
    final theme = await repository.setTheme(event.brightness);

    theme.fold(
      (fail) => emit(ThemeInitialState()),
      (right) => emit(
        ChangeThemeState(
          ThemeStateModel(
            theme: right,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onGetThemeEvent(
    GetThemeEvent event,
    Emitter<PreferencesState> emit,
  ) async {
    final theme = await repository.getTheme();

    theme.fold(
      (fail) => emit(ThemeInitialState()),
      (right) => emit(
        ChangeThemeState(
          ThemeStateModel(
            theme: right,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeLocaleEvent(
    ChangeLocaleEvent event,
    Emitter<PreferencesState> emit,
  ) async {
    await repository.setLanguage(event.locale.toString());

    emit(
      ChangeThemeState(
        ThemeStateModel(
          theme: state.model.theme,
          locale: event.locale,
        ),
      ),
    );
  }

  FutureOr<void> _onGetLanguageEvent(
    GetLanguageEvent event,
    Emitter<PreferencesState> emit,
  ) async {
    final response = await repository.getLanguage();

    response.fold(
      (fail) => emit(ThemeInitialState()),
      (right) => emit(
        ChangeThemeState(
          ThemeStateModel(
            theme: state.model.theme,
            locale: right != null ? Locale(right) : const Locale('en'),
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onGetAppVersion(
    GetAppVersion event,
    Emitter<PreferencesState> emit,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    emit(
      ChangeThemeState(
        ThemeStateModel(
          theme: state.model.theme,
          appVersion: packageInfo.version,
        ),
      ),
    );
  }
}
