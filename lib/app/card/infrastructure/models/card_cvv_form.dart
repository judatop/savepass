import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/utils/form_utils.dart';

enum CardCvvFormValidationError {
  empty,
  minLength,
  maxLength,
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

    if (value.length > FormUtils.maxLength) {
      return CardCvvFormValidationError.maxLength;
    }

    return null;
  }

  String? getError(AppLocalizations intl10, CardCvvFormValidationError? error) {
    switch (error) {
      case CardCvvFormValidationError.empty:
        return intl10.mandatoryField;
      case CardCvvFormValidationError.minLength:
        return intl10.cvvMinLength;
      case CardCvvFormValidationError.maxLength:
        return intl10.maxLengthField;
      default:
        return null;
    }
  }
}
