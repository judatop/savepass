import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/preferences/domain/entities/preferences_entity.dart';

abstract class PreferencesEvent extends Equatable {
  const PreferencesEvent();

  @override
  List<Object> get props => [];
}

class ToggleBrightnessEvent extends PreferencesEvent {
  final BrightnessType brightness;

  const ToggleBrightnessEvent({required this.brightness}) : super();
}

class ChangeLocaleEvent extends PreferencesEvent {
  final Locale locale;

  const ChangeLocaleEvent({required this.locale}) : super();
}

class GetPreferencesEvent extends PreferencesEvent {
  const GetPreferencesEvent() : super();
}