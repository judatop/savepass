import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TextFormValidationError {
  empty,
  atLeast3Characters,
}

class TextForm extends FormzInput<String, TextFormValidationError> {
  const TextForm.pure() : super.pure('');

  const TextForm.dirty([super.value = '']) : super.dirty();

  @override
  TextFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return TextFormValidationError.empty;
    }

    if (value.length < 3) {
      return TextFormValidationError.atLeast3Characters;
    }

    return null;
  }

  String? getError(BuildContext context, TextFormValidationError? error) {
    final appLocalizations = AppLocalizations.of(context)!;

    switch (error) {
      case TextFormValidationError.empty:
        return appLocalizations.mandatoryField;
      case TextFormValidationError.atLeast3Characters:
        return appLocalizations.nameAtLeast3Characters;
      default:
        return null;
    }
  }
}
