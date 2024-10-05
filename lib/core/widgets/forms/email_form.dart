import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum EmailFormValidationError { invalid, empty }

class EmailForm extends FormzInput<String, EmailFormValidationError> {
  const EmailForm.pure() : super.pure('');

  const EmailForm.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return EmailFormValidationError.empty;
    }

    if (!_emailRegExp.hasMatch(value)) {
      return EmailFormValidationError.invalid;
    }

    return null;
  }

  String? getError(BuildContext context, EmailFormValidationError? error) {
    final appLocalizations = AppLocalizations.of(context)!;

    switch (error) {
      case EmailFormValidationError.invalid:
        return appLocalizations.incorrectEmail;
      case EmailFormValidationError.empty:
        return appLocalizations.mandatoryField;
      default:
        return null;
    }
  }
}
