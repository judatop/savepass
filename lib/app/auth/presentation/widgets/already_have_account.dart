import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appLocalizations = AppLocalizations.of(context)!;
    final bloc = Modular.get<AuthBloc>();
    final deviceHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: colorScheme.brightness == Brightness.light
            ? Colors.transparent
            : Colors.grey[900],
        child: Padding(
          padding: EdgeInsets.only(
            top: deviceHeight * 0.01,
            bottom: deviceHeight * (Platform.isAndroid ? 0.01 : 0.03),
          ),
          child: Column(
            children: [
              if (colorScheme.brightness == Brightness.light) const Divider(),
              AdsTextButton(
                text: appLocalizations.signUpAlreadyAccount,
                onPressedCallback: () => bloc.add(const OpenSignInEvent()),
                textStyle: const TextStyle(
                  color: ADSFoundationsColors.linkColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
