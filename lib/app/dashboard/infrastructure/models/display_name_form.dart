import 'package:formz/formz.dart';
import 'package:savepass/l10n/app_localizations.dart';

enum DisplayNameFormValidationError {
  empty,
}

class DisplayNameForm
    extends FormzInput<String, DisplayNameFormValidationError> {
  const DisplayNameForm.pure() : super.pure('');

  const DisplayNameForm.dirty([super.value = '']) : super.dirty();

  @override
  DisplayNameFormValidationError? validator(String? value) {
    return null;
  }

  String? getError(
    AppLocalizations intl10,
    DisplayNameFormValidationError? error,
  ) {
    return null;
  }
}
