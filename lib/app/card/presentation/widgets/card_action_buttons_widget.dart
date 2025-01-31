import 'dart:io';

import 'package:atomic_design_system/foundations/ads_foundation_sizes.dart';
import 'package:atomic_design_system/molecules/button/ads_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardActionButtonsWidget extends StatelessWidget {
  const CardActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: colorScheme.brightness == Brightness.light
            ? Colors.transparent
            : Colors.black,
        child: Column(
          children: [
            if (colorScheme.brightness == Brightness.light) const Divider(),
            Padding(
              padding: EdgeInsets.only(
                left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                right:
                    deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                top: colorScheme.brightness == Brightness.dark
                    ? deviceHeight * 0.02
                    : deviceHeight * 0.01,
                bottom: deviceHeight * (Platform.isAndroid ? 0.025 : 0.04),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdsFilledButton(
                    onPressedCallback: () {},
                    text: intl.saveText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
