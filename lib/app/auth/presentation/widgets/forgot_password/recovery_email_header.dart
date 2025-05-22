import 'dart:io';

import 'package:atomic_design_system/molecules/button/ads_filled_round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecoveryEmailHeader extends StatelessWidget {
  const RecoveryEmailHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ],
    );
  }
}
