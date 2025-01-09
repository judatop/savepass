import 'package:atomic_design_system/foundations/ads_foundation_sizes.dart';
import 'package:atomic_design_system/molecules/button/ads_filled_round_icon_button.dart';
import 'package:atomic_design_system/molecules/text/ads_headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/password/presentation/blocs/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';

class PassHeaderWidget extends StatelessWidget {
  const PassHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) =>
          previous.model.isUpdating != current.model.isUpdating,
      builder: (context, state) {
        final isUpdating = state.model.isUpdating;

        return Column(
          children: [
            SizedBox(
              height: (ADSFoundationSizes.defaultVerticalPadding / 2) *
                  screenHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Flexible(
                  child: AdsHeadline(
                    text: isUpdating
                        ? intl.passwordEditTitle
                        : intl.passwordTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
