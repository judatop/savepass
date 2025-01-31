import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum CardCvvFormValidationError {
  empty,
  minLength,
}

class CardCvvForm extends FormzInput<String, CardCvvFormValidationError> {
  const CardCvvForm.pure() : super.pure('');

  const CardCvvForm.dirty([super.value = '']) : super.dirty();

  @override
  CardCvvFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return CardCvvFormValidationError.empty;
    }

    if (value.length != 3) {
      return CardCvvFormValidationError.minLength;
    }

    return null;
  }

  String? getError(AppLocalizations intl10, CardCvvFormValidationError? error) {
    switch (error) {
      case CardCvvFormValidationError.empty:
        return intl10.mandatoryField;
      case CardCvvFormValidationError.minLength:
        return intl10.cvvMinLength;
      default:
        return null;
    }
  }
}
