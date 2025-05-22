import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/core/config/routes.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => Modular.to.pushNamed(Routes.forgotPasswordRoute),
      child: Text(
        intl.forgotPassword,
        style: TextStyle(color: Colors.grey[600]),
        textAlign: TextAlign.start,
      ),
    );
  }
}
