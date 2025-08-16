import 'package:formz/formz.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/core/utils/form_utils.dart';

enum TextFormValidationError { empty, maxLength }

class TextForm extends FormzInput<String, TextFormValidationError> {
  const TextForm.pure() : super.pure('');

  const TextForm.dirty([super.value = '']) : super.dirty();

  @override
  TextFormValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return TextFormValidationError.empty;
    }

    if (value.length > FormUtils.maxLength) {
      return TextFormValidationError.maxLength;
    }

    return null;
  }

  String? getError(AppLocalizations intl10, TextFormValidationError? error) {
    switch (error) {
      case TextFormValidationError.empty:
        return intl10.mandatoryField;
      case TextFormValidationError.maxLength:
        return intl10.maxLengthField;
      default:
        return null;
    }
  }
}
