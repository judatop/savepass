import 'package:atomic_design_system/foundations/ads_foundation_sizes.dart';
import 'package:atomic_design_system/molecules/button/ads_filled_round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BiometricHeaderWidget extends StatelessWidget {
  const BiometricHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height:
              (ADSFoundationSizes.defaultVerticalPadding / 2) * screenHeight,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AdsFilledRoundIconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
              ),
              onPressedCallback: () {
                Modular.to.pop();
              },
            ),
            SizedBox(
              width: screenWidth * 0.02,
            ),
          ],
        ),
      ],
    );
  }
}
