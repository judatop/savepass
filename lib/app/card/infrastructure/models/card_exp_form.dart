import 'package:formz/formz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/utils/form_utils.dart';

enum CardExpFormValidationError {
  empty,
  minLength,
  maxLength,
}

class CardExpForm extends FormzInput<String, CardExpFormValidationError> {
  const CardExpForm.pure() : super.pure('');

  const CardExpForm.dirty([super.value = '']) : super.dirty();

  @override
  CardExpFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return CardExpFormValidationError.empty;
    }

    if (value.length != 2) {
      return CardExpFormValidationError.minLength;
    }

    if (value.length > FormUtils.maxLength) {
      return CardExpFormValidationError.maxLength;
    }

    return null;
  }

  String? getError(AppLocalizations intl10, CardExpFormValidationError? error) {
    switch (error) {
      case CardExpFormValidationError.empty:
        return intl10.mandatoryField;
      case CardExpFormValidationError.minLength:
        return intl10.cardExpMinLength;
      case CardExpFormValidationError.maxLength:
        return intl10.maxLengthField;
      default:
        return null;
    }
  }
}
