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

  String? getError(AppLocalizations intl10, TextFormValidationError? error) {
    switch (error) {
      case TextFormValidationError.empty:
        return intl10.mandatoryField;
      default:
        return null;
    }
  }
}
