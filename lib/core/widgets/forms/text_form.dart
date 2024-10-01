import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TextFormValidationError {
  empty,
}

class TextForm extends FormzInput<String, TextFormValidationError> {
  const TextForm.pure() : super.pure('');

  const TextForm.dirty([super.value = '']) : super.dirty();

  @override
  TextFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return TextFormValidationError.empty;
    }

    return null;
  }

  String? getError(BuildContext context, TextFormValidationError? error) {
    final appLocalizations = AppLocalizations.of(context)!;

    switch (error) {
      case TextFormValidationError.empty:
        return appLocalizations.mandatoryField;
      default:
        return null;
    }
  }
}
