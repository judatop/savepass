import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/utils/form_utils.dart';

enum PasswordFormValidationError { empty, maxLength }

class PasswordForm extends FormzInput<String, PasswordFormValidationError> {
  const PasswordForm.pure() : super.pure('');

  const PasswordForm.dirty([super.value = '']) : super.dirty();

  @override
  PasswordFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordFormValidationError.empty;
    }

    if (value.length > FormUtils.maxLength) {
      return PasswordFormValidationError.maxLength;
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
      case PasswordFormValidationError.maxLength:
        return intl10.maxLengthField;
      default:
        return null;
    }
  }
}
