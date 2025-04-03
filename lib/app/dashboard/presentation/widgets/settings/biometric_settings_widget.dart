import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/core/config/routes.dart';

class BiometricSettingsWidget extends StatelessWidget {
  const BiometricSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final deviceHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          (previous.model.hasBiometrics != current.model.hasBiometrics) ||
          (previous.model.canAuthenticate != current.model.canAuthenticate),
      builder: (context, state) {
        final hasBiometrics = state.model.hasBiometrics;
        final canAuthenticate = state.model.canAuthenticate;

        if (hasBiometrics || !canAuthenticate) {
          return Container();
        }

        debugPrint(
          'hasBiometrics: $hasBiometrics, canAuthenticate: $canAuthenticate',
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdsTitle(
                      text: intl.biometrics,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      intl.biometricsTip,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    AdsFilledIconButton(
                      onPressedCallback: () =>
                          Modular.to.pushNamed(Routes.biometricRoute),
                      text: intl.enableBiometricsTitle,
                      icon: Platform.isAndroid ? Icons.fingerprint : Icons.face,
                    ),
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
