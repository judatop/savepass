import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/utils/form_utils.dart';
import 'package:savepass/core/utils/password_utils.dart';

enum SignUpPasswordFormValidationError {
  empty,
  atLeast8Characters,
  containsLowerCase,
  containsUpperCase,
  containsNumber,
  maxLength,
}

class SignUpPasswordForm
    extends FormzInput<String, SignUpPasswordFormValidationError> {
  const SignUpPasswordForm.pure() : super.pure('');

  const SignUpPasswordForm.dirty([super.value = '']) : super.dirty();

  @override
  SignUpPasswordFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return SignUpPasswordFormValidationError.empty;
    }

    if (!PasswordUtils.atLeast8Characters(value)) {
      return SignUpPasswordFormValidationError.atLeast8Characters;
    }

    if (!PasswordUtils.containsLowerCase(value)) {
      return SignUpPasswordFormValidationError.containsLowerCase;
    }

    if (!PasswordUtils.containsUpperCase(value)) {
      return SignUpPasswordFormValidationError.containsUpperCase;
    }

    if (!PasswordUtils.containsNumber(value)) {
      return SignUpPasswordFormValidationError.containsNumber;
    }

    if (value.length > FormUtils.maxLength) {
      return SignUpPasswordFormValidationError.maxLength;
    }

    return null;
  }

  String? getError(
    AppLocalizations intl,
    SignUpPasswordFormValidationError? error,
  ) {
    switch (error) {
      case SignUpPasswordFormValidationError.empty:
        return intl.mandatoryField;
      case SignUpPasswordFormValidationError.atLeast8Characters:
        return intl.atLeast8Characters;
      case SignUpPasswordFormValidationError.maxLength:
        return intl.maxLengthField;
      case SignUpPasswordFormValidationError.containsLowerCase:
        return intl.containsLowerCase;
      case SignUpPasswordFormValidationError.containsUpperCase:
        return intl.containsUpperCase;
      case SignUpPasswordFormValidationError.containsNumber:
        return intl.containsNumber;
      default:
        return null;
    }
  }
}
