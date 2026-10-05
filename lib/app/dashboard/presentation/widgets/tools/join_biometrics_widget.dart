import 'dart:io';

import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/l10n/app_localizations.dart';

class JoinBiometricsWidget extends StatelessWidget {
  const JoinBiometricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final deviceWidth = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = colorScheme.brightness == Brightness.light;

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

        return AdsCard(
          onTap: () => Modular.to.pushNamed(Routes.biometricRoute),
          bgColor: isLight ? const Color(0xFFE8E8E8) : Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Platform.isAndroid ? Icons.fingerprint : Icons.face,
              ),
              SizedBox(width: deviceWidth * 0.02),
              Text(
                intl.enableBiometricsTitle,
                style: textTheme.titleMedium?.copyWith(
                  color: isLight ? Colors.black : Colors.white,
                  fontSize: 19.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
