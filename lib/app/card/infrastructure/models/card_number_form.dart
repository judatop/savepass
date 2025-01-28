import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum CardNumberFormValidationError {
  empty,
  minLength,
}

class CardNumberForm extends FormzInput<String, CardNumberFormValidationError> {
  const CardNumberForm.pure() : super.pure('');

  const CardNumberForm.dirty([super.value = '']) : super.dirty();

  @override
  CardNumberFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return CardNumberFormValidationError.empty;
    }

    if(value.length != 16){
      return CardNumberFormValidationError.minLength;
    }

    return null;
  }

  String? getError(AppLocalizations intl10, CardNumberFormValidationError? error) {
    switch (error) {
      case CardNumberFormValidationError.empty:
        return intl10.mandatoryField;
      case CardNumberFormValidationError.minLength:
        return intl10.cardMinLength;
      default:
        return null;
    }
  }
}
