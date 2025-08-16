import 'package:formz/formz.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/core/utils/form_utils.dart';

enum CardNumberFormValidationError { empty, minLength, maxLength }

class CardNumberForm extends FormzInput<String, CardNumberFormValidationError> {
  const CardNumberForm.pure() : super.pure('');

  const CardNumberForm.dirty([super.value = '']) : super.dirty();

  @override
  CardNumberFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return CardNumberFormValidationError.empty;
    }

    if (value.length != 16) {
      return CardNumberFormValidationError.minLength;
    }

    if (value.length > FormUtils.maxLength) {
      return CardNumberFormValidationError.maxLength;
    }

    return null;
  }

  String? getError(
      AppLocalizations intl10, CardNumberFormValidationError? error) {
    switch (error) {
      case CardNumberFormValidationError.empty:
        return intl10.mandatoryField;
      case CardNumberFormValidationError.minLength:
        return intl10.cardMinLength;
      case CardNumberFormValidationError.maxLength:
        return intl10.maxLengthField;
      default:
        return null;
    }
  }
}
