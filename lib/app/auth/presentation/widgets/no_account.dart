import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/core/config/routes.dart';

class NoAccount extends StatelessWidget {
  const NoAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appLocalizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: colorScheme.brightness == Brightness.light
            ? Colors.transparent
            : Colors.grey[900],
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.01,
            bottom: screenHeight * (Platform.isAndroid ? 0.01 : 0.03),
          ),
          child: Column(
            children: [
              if (colorScheme.brightness == Brightness.light) const Divider(),
              AdsTextButton(
                text: appLocalizations.signInNoAccount,
                onPressedCallback: () {
                  Modular.to.pop();
                  Modular.to
                      .pushNamed(Routes.authRoute, arguments: AuthType.signUp);
                },
                textStyle: const TextStyle(
                  color: ADSFoundationsColors.linkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
