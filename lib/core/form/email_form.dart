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

  String? getError(AppLocalizations intl10, EmailFormValidationError? error) {
    switch (error) {
      case EmailFormValidationError.invalid:
        return intl10.incorrectEmail;
      case EmailFormValidationError.empty:
        return intl10.mandatoryField;
      default:
        return null;
    }
  }
}
