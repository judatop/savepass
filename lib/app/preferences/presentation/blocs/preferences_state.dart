import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/preferences/infrastructure/models/preferences_model.dart';
import 'package:savepass/app/preferences/utils/preferences_utils.dart';

abstract class PreferencesState extends Equatable {
  final ThemeStateModel model;

  const PreferencesState(this.model);

  @override
  List<Object> get props => [model];
}

class ThemeInitialState extends PreferencesState {
  ThemeInitialState() : super(PreferencesUtils.defaultAccountPreferencesModel);
}

class ChangeThemeState extends PreferencesState {
  const ChangeThemeState(super.model);
}

class ThemeStateModel extends Equatable {
  final PreferencesModel theme;
  final Locale locale;
  final String appVersion;

  const ThemeStateModel({
    required this.theme,
    this.locale = const Locale('es'),
    this.appVersion = '',
  });

  ThemeStateModel copyWith({
    PreferencesModel? theme,
    Locale? locale,
    String? appVersion,
  }) {
    return ThemeStateModel(
      theme: theme ?? this.theme,
      locale: locale ?? this.locale,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  List<Object?> get props => [
        theme,
        locale,
        appVersion,
      ];
}
