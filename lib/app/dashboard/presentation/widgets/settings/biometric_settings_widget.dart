import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:atomic_design_system/molecules/text/ads_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';

class BiometricSettingsWidget extends StatelessWidget {
  const BiometricSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final deviceHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.model.hasBiometrics != current.model.hasBiometrics,
      builder: (context, state) {
        final hasBiometrics = state.model.hasBiometrics;

        if (hasBiometrics) {
          return Container();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AdsTitle(
                      text: 'Biometrics',
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      intl.appLanguageDesc,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.02),
          ],
        );
      },
    );
  }
}
