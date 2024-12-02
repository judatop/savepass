import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class LanguageSettingsWidget extends StatelessWidget {
  const LanguageSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdsCard(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdsTitle(
              text: 'App Language',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Text(
              'You can change the language of the app here.',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
