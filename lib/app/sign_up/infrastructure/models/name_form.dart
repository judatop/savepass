import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TextFormValidationError {
  empty,
  atLeast3Characters,
}

class NameForm extends FormzInput<String, TextFormValidationError> {
  const NameForm.pure() : super.pure('');

  const NameForm.dirty([super.value = '']) : super.dirty();

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

  String? getError(AppLocalizations intl, TextFormValidationError? error) {
    switch (error) {
      case TextFormValidationError.empty:
        return intl.mandatoryField;
      case TextFormValidationError.atLeast3Characters:
        return intl.nameAtLeast3Characters;
      default:
        return null;
    }
  }
}
