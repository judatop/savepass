import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class TermsSettingsWidget extends StatelessWidget {
  const TermsSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdsCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AdsTitle(
              text: 'Terms of Conditions',
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            const Text(
              'You can check our Terms of Conditions here.',
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            AdsOutlinedButton(
              onPressedCallback: () {},
              text: 'Terms',
            ),
          ],
        ),
      ),
    );
  }
}
