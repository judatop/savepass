import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_bloc.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';

class PassHeaderWidget extends StatelessWidget {
  const PassHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<PasswordBloc>();
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
              mainAxisAlignment: isUpdating
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                AdsFilledRoundIconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                  ),
                  onPressedCallback: () {
                    Modular.to.pop();
                  },
                ),
                if (!isUpdating)
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                isUpdating
                    ? AdsFilledRoundIconButton(
                        backgroundColor: ADSFoundationsColors.errorBackground,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressedCallback: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(intl.attentionTitle),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                        intl.deletePasswordText,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  AdsFilledIconButton(
                                    onPressedCallback: () {
                                      Modular.to.pop();
                                      bloc.add(const DeletePasswordEvent());
                                    },
                                    text: intl.acceptButton,
                                    icon: Icons.check,
                                  ),
                                  TextButton(
                                    child: Text(
                                      intl.cancelButton,
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onPressed: () {
                                      Modular.to.pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : AdsHeadline(
                        text: isUpdating
                            ? intl.passwordEditTitle
                            : intl.passwordTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}
