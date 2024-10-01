import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInFooterWidget extends StatelessWidget {
  const SignInFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final appLocalizations = AppLocalizations.of(context)!;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: colorScheme.brightness == Brightness.light
            ? Colors.transparent
            : Colors.black,
        child: Padding(
          padding: EdgeInsets.only(
            bottom:
                Platform.isAndroid ? deviceHeight * 0.01 : deviceHeight * 0.03,
            top: deviceHeight * 0.01,
          ),
          child: Column(
            children: [
              if (colorScheme.brightness == Brightness.light) const Divider(),
              AdsTextButton(
                text: appLocalizations.signInNoAccount,
                onPressedCallback: () {},
                textStyle: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
