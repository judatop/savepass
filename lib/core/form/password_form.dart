import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PasswordFormValidationError { empty }

class PasswordForm extends FormzInput<String, PasswordFormValidationError> {
  const PasswordForm.pure() : super.pure('');

  const PasswordForm.dirty([super.value = '']) : super.dirty();

  @override
  PasswordFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordFormValidationError.empty;
    }

    return null;
  }

  String? getError(
    AppLocalizations intl10,
    PasswordFormValidationError? error,
  ) {
    switch (error) {
      case PasswordFormValidationError.empty:
        return intl10.mandatoryField;
      default:
        return null;
    }
  }
}
