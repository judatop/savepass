import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';

class BiometricSettingsWidget extends StatelessWidget {
  const BiometricSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final deviceHeight = MediaQuery.of(context).size.height;
    final bloc = Modular.get<DashboardBloc>();

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          previous.model.hasBiometrics != current.model.hasBiometrics,
      builder: (context, state) {
        final hasBiometrics = state.model.hasBiometrics;
        final canAuthenticate = state.model.canAuthenticate;

        if (hasBiometrics || !canAuthenticate) {
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
                    const Text(
                      'Sign in with biometrics for a faster and more secure experience.',
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: deviceHeight * 0.02),
                    AdsFilledIconButton(
                      onPressedCallback: () =>
                          bloc.add(const EnableBiometricsEvent()),
                      text: 'Enable Biometrics',
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
