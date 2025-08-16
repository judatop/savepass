import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/core/config/routes.dart';

class UpdateMasterPasswordWidget extends StatelessWidget {
  const UpdateMasterPasswordWidget({super.key});

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
              text: intl.updateMasterPasswordTitle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(
              intl.updateMasterPasswordText,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            AdsOutlinedButton(
              onPressedCallback: () =>
                  Modular.to.pushNamed(Routes.masterPasswordRoute),
              text: intl.updateText,
            ),
          ],
        ),
      ),
    );
  }
}
