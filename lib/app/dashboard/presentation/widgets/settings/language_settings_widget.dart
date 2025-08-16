import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/language_dropdown_widget.dart';

class LanguageSettingsWidget extends StatelessWidget {
  const LanguageSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AdsCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdsTitle(
              text: intl.appLanguage,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(
              intl.appLanguageDesc,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            LanguageDropdownWidget(),
          ],
        ),
      ),
    );
  }
}
