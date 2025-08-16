import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        if (Platform.isAndroid) SizedBox(height: screenHeight * 0.015),
        Row(
          children: [
            AdsFilledRoundIconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
              ),
              onPressedCallback: () {
                Modular.to.pop();
              },
            ),
            SizedBox(width: screenWidth * 0.05),
            Flexible(
              child: AdsHeadline(
                text: intl.forgotPasswordTitle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
