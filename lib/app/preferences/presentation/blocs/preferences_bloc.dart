import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/infrastructure/models/preferences_model.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_event.dart';
import 'package:savepass/app/preferences/presentation/blocs/preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository repository;

  PreferencesBloc(this.repository) : super(const ThemeInitialState()) {
    on<GetPreferencesEvent>(_onGetPreferencesEvent);
    on<ToggleBrightnessEvent>(onToggleBrightness);
    on<ChangeLocaleEvent>(_onChangeLocaleEvent);
  }

  FutureOr<void> onToggleBrightness(
    ToggleBrightnessEvent event,
    Emitter<PreferencesState> emit,
  ) async {
    final theme = await repository.setTheme(event.brightness);

    theme.fold(
      (fail) => emit(const ThemeInitialState()),
      (right) => emit(
        ChangePreferencesState(
          state.model.copyWith(
            theme: right,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onGetPreferencesEvent(
    GetPreferencesEvent event,
    Emitter<PreferencesState> emit,
  ) async {
    final themeResponse = await repository.getTheme();
    PreferencesModel? brightness;
    themeResponse.fold(
      (fail) => emit(const ThemeInitialState()),
      (right) {
        brightness = right;
      },
    );

    final languageResponse = await repository.getLanguage();
    String? language;
    languageResponse.fold(
      (fail) => emit(const ThemeInitialState()),
      (right) {
        language = right;
      },
    );

    final packageInfo = await PackageInfo.fromPlatform();

    emit(
      ChangePreferencesState(
        state.model.copyWith(
          theme: brightness,
          locale: language != null ? Locale(language!) : const Locale('es'),
          appVersion: packageInfo.version,
        ),
      ),
    );
  }

  FutureOr<void> _onChangeLocaleEvent(
    ChangeLocaleEvent event,
    Emitter<PreferencesState> emit,
  ) async {
    final localeResponse =
        await repository.setLanguage(event.locale.toString());

    localeResponse.fold((fail) {}, (right) {
      emit(
        ChangePreferencesState(
          state.model.copyWith(
            locale: event.locale,
          ),
        ),
      );
    });
  }
}
