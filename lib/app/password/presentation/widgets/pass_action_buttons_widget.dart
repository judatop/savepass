import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/password/presentation/blocs/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PassActionButtonsWidget extends StatelessWidget {
  const PassActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final bloc = Modular.get<PasswordBloc>();
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: colorScheme.brightness == Brightness.light
            ? Colors.transparent
            : Colors.black,
        child: Column(
          children: [
            if (colorScheme.brightness == Brightness.light) const Divider(),
            Padding(
              padding: EdgeInsets.only(
                left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                right:
                    deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                top: colorScheme.brightness == Brightness.dark
                    ? deviceHeight * 0.02
                    : deviceHeight * 0.01,
                bottom: deviceHeight * (Platform.isAndroid ? 0.025 : 0.04),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocBuilder<PasswordBloc, PasswordState>(
                    buildWhen: (previous, current) =>
                        previous.model.status != current.model.status,
                    builder: (context, state) {
                      final status = state.model.status;

                      return Skeletonizer(
                        enabled: status.isInProgress,
                        child: AdsFilledButton(
                          onPressedCallback: () =>
                              bloc.add(const SubmitPasswordEvent()),
                          text: intl.saveText,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
