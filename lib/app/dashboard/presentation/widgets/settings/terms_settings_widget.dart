import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';

class TermsSettingsWidget extends StatelessWidget {
  const TermsSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<DashboardBloc>();
    final intl = AppLocalizations.of(context)!;

    return AdsCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdsTitle(
              text: intl.termsTitle,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(
              intl.termsText,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            AdsOutlinedButton(
              onPressedCallback: () => bloc.add(const OpenTermsEvent()),
              text: intl.openTerms,
            ),
          ],
        ),
      ),
    );
  }
}
