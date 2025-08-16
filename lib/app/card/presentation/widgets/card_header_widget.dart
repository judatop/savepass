import 'package:atomic_design_system/foundations/ads_foundation_sizes.dart';
import 'package:atomic_design_system/foundations/ads_foundations_colors.dart';
import 'package:atomic_design_system/molecules/button/ads_filled_icon_button.dart';
import 'package:atomic_design_system/molecules/button/ads_filled_round_icon_button.dart';
import 'package:atomic_design_system/molecules/text/ads_headline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_bloc.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_event.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_state.dart';

class CardHeaderWidget extends StatelessWidget {
  const CardHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bloc = Modular.get<CardBloc>();

    return BlocBuilder<CardBloc, CardState>(
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
                BlocBuilder<CardBloc, CardState>(
                  buildWhen: (previous, current) =>
                      (previous.model.cardNumber.value !=
                          current.model.cardNumber.value) ||
                      (previous.model.cardHolderName.value !=
                          current.model.cardHolderName.value) ||
                      (previous.model.cardCvv.value !=
                          current.model.cardCvv.value) ||
                      (previous.model.expirationMonth.value !=
                          current.model.expirationMonth.value) ||
                      (previous.model.expirationYear.value !=
                          current.model.expirationYear.value),
                  builder: (context, state) {
                    final cardNumber = state.model.cardNumber.value;
                    final cardHolderName = state.model.cardHolderName.value;
                    final cardCvv = state.model.cardCvv.value;
                    final expirationMonth = state.model.expirationMonth.value;
                    final expirationYear = state.model.expirationYear.value;

                    return AdsFilledRoundIconButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                      ),
                      onPressedCallback: () {
                        if (cardNumber.isEmpty &&
                            cardHolderName.isEmpty &&
                            cardCvv.isEmpty &&
                            expirationMonth.isEmpty &&
                            expirationYear.isEmpty) {
                          Modular.to.pop();
                          return;
                        }

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
                                      intl.goBackText,
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                AdsFilledIconButton(
                                  onPressedCallback: () {
                                    Modular.to.pop();
                                    Modular.to.pop();
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
                    );
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
                                        intl.deleteCardText,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  AdsFilledIconButton(
                                    onPressedCallback: () {
                                      Modular.to.pop();
                                      bloc.add(const DeleteCardEvent());
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
                        text:
                            isUpdating ? intl.editCardTitle : intl.newCardTitle,
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
