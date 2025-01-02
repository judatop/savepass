import 'package:atomic_design_system/foundations/ads_foundation_sizes.dart';
import 'package:atomic_design_system/molecules/button/ads_filled_round_icon_button.dart';
import 'package:atomic_design_system/molecules/text/ads_headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PassHeaderWidget extends StatelessWidget {
  const PassHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height:
              (ADSFoundationSizes.defaultVerticalPadding / 2) * screenHeight,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                text: intl.passwordTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
