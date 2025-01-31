import 'dart:io';

import 'package:atomic_design_system/molecules/button/ads_filled_round_icon_button.dart';
import 'package:atomic_design_system/molecules/text/ads_headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        if (Platform.isAndroid) SizedBox(height: screenHeight * 0.015),
        Row(
          children: [
            AdsFilledRoundIconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
              ),
              onPressedCallback: () {
                Modular.to.pop();
              },
            ),
            SizedBox(width: screenWidth * 0.05),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final authType = state.model.authType;

                return AdsHeadline(
                  text: authType == AuthType.signUp
                      ? intl.getStartedSingUp
                      : intl.getStartedSingIn,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
