import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class DeleteAccountSettingsWidget extends StatelessWidget {
  const DeleteAccountSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdsCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AdsTitle(
              text: 'Delete Account',
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            const Text(
              'By deleting your account, all your data will be lost',
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            AdsFilledButton(
              onPressedCallback: () {},
              text: 'Delete account',
              buttonStyle: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  ADSFoundationsColors.errorBackground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
