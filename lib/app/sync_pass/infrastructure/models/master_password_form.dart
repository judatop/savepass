import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/utils/password_utils.dart';

enum MasterPasswordFormValidationError {
  empty,
  atLeast8Characters,
  containsLowerCase,
  containsUpperCase,
  containsNumber,
  containsSpecialCharacter,
  notContains3RepeatedCharacters,
  notContains3ConsecutiveCharacters
}

class MasterPasswordForm
    extends FormzInput<String, MasterPasswordFormValidationError> {
  const MasterPasswordForm.pure() : super.pure('');

  const MasterPasswordForm.dirty([super.value = '']) : super.dirty();

  @override
  MasterPasswordFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return MasterPasswordFormValidationError.empty;
    }

    if (!PasswordUtils.atLeast8Characters(value)) {
      return MasterPasswordFormValidationError.atLeast8Characters;
    }

    if (!PasswordUtils.containsLowerCase(value)) {
      return MasterPasswordFormValidationError.containsLowerCase;
    }

    if (!PasswordUtils.containsUpperCase(value)) {
      return MasterPasswordFormValidationError.containsUpperCase;
    }

    if (!PasswordUtils.containsNumber(value)) {
      return MasterPasswordFormValidationError.containsNumber;
    }

    if (!PasswordUtils.containsSpecialCharacter(value)) {
      return MasterPasswordFormValidationError.containsSpecialCharacter;
    }

    if (!PasswordUtils.notContains3RepeatedCharacters(value)) {
      return MasterPasswordFormValidationError.notContains3RepeatedCharacters;
    }

    if (!PasswordUtils.notContains3ConsecutiveCharacters(value)) {
      return MasterPasswordFormValidationError
          .notContains3ConsecutiveCharacters;
    }

    return null;
  }

  String? getError(
    AppLocalizations intl,
    MasterPasswordFormValidationError? error,
  ) {
    switch (error) {
      case MasterPasswordFormValidationError.empty:
        return intl.mandatoryField;
      case MasterPasswordFormValidationError.atLeast8Characters:
        return intl.atLeast8Characters;
      case MasterPasswordFormValidationError.containsLowerCase:
        return intl.containsLowerCase;
      case MasterPasswordFormValidationError.containsUpperCase:
        return intl.containsUpperCase;
      case MasterPasswordFormValidationError.containsNumber:
        return intl.containsNumber;
      case MasterPasswordFormValidationError.containsSpecialCharacter:
        return intl.containsSpecialCharacter;
      case MasterPasswordFormValidationError.notContains3RepeatedCharacters:
        return intl.notContains3RepeatedCharacters;
      case MasterPasswordFormValidationError.notContains3ConsecutiveCharacters:
        return intl.notContains3ConsecutiveCharacters;
      default:
        return null;
    }
  }
}
