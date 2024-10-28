import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SnackBarUtils {
  static void showErrroSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final intl = AppLocalizations.of(context)!;

    final snackbar = SnackBar(
      backgroundColor: ADSFoundationsColors.errorBackground,
      content: Text(
        message,
        style: const TextStyle(
          color: ADSFoundationsColors.whiteColor,
        ),
      ),
      action: SnackBarAction(
        label: intl.close,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      duration: const Duration(
        seconds: 3,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final intl = AppLocalizations.of(context)!;

    final snackbar = SnackBar(
      backgroundColor: ADSFoundationsColors.successBackground,
      content: Text(
        message,
      ),
      action: SnackBarAction(
        label: intl.close,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      duration: const Duration(
        seconds: 3,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
