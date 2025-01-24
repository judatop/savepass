import 'package:animate_do/animate_do.dart';
import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/card/infrastructure/models/card_type.dart';
import 'package:savepass/app/card/presentation/blocs/card_bloc.dart';
import 'package:savepass/app/card/presentation/blocs/card_state.dart';
import 'package:savepass/app/card/utils/card_utils.dart';
import 'package:savepass/core/image/image_paths.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    return AdsCard(
      elevation: 1.5,
      bgColor: colorScheme.primary.withOpacity(0.8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.05,
          vertical: deviceHeight * 0.02,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<CardBloc, CardState>(
                  buildWhen: (previous, current) =>
                      previous.model.cardType != current.model.cardType,
                  builder: (context, state) {
                    final cardType = state.model.cardType;

                    return Skeletonizer(
                      enabled: (cardType != CardType.visa &&
                          cardType != CardType.americanExpress),
                      child: Text(
                        cardType == CardType.visa ? 'VISA' : 'AMERICAN EXPRESS',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                        textAlign: cardType == CardType.visa
                            ? TextAlign.start
                            : TextAlign.center,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                Skeletonizer(
                  enabled: false,
                  child: Image.asset(
                    ImagePaths.chipImage,
                    height: 50,
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                BlocBuilder<CardBloc, CardState>(
                  buildWhen: (previous, current) =>
                      (previous.model.cardNumber != current.model.cardNumber),
                  builder: (context, state) {
                    final number = state.model.cardNumber.value;

                    return Skeletonizer(
                      enabled: number.isEmpty,
                      child: BounceInRight(
                        child: Text(
                          number.isEmpty
                              ? '9999 9999 99999 9999'
                              : CardUtils.formatCreditCardNumber(number),
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            wordSpacing: deviceWidth * 0.025,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: deviceHeight * 0.005),
                BlocBuilder<CardBloc, CardState>(
                  buildWhen: (previous, current) =>
                      (previous.model.cardHolderName !=
                          current.model.cardHolderName),
                  builder: (context, state) {
                    final cardHolderName = state.model.cardHolderName.value;

                    return Skeletonizer(
                      enabled: cardHolderName.isEmpty,
                      child: BounceInRight(
                        child: Text(
                          cardHolderName.isEmpty
                              ? 'XXXXXXX XXXXXXX'
                              : cardHolderName,
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            wordSpacing: deviceWidth * 0.01,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: deviceHeight * 0.01),
                Container(
                  color: Colors.blue,
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<CardBloc, CardState>(
                        buildWhen: (previous, current) =>
                            (previous.model.expirationMonth !=
                                current.model.expirationMonth) ||
                            (previous.model.expirationYear !=
                                current.model.expirationYear),
                        builder: (context, state) {
                          final expirationMonth =
                              state.model.expirationMonth.value;
                          final expirationYear =
                              state.model.expirationYear.value;

                          return Skeletonizer(
                            enabled: expirationMonth.isEmpty,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'VÁLIDO',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      'HASTA',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: deviceWidth * 0.03,
                                ),
                                BounceInRight(
                                  child: Text(
                                    (expirationMonth.isEmpty &&
                                            expirationYear.isEmpty)
                                        ? '00/00'
                                        : '$expirationMonth/$expirationYear',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      wordSpacing: deviceWidth * 0.01,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Container(
                      //   color: Colors.yellow,
                      //   child: Image.asset(
                      //     ImagePaths.masterCardImage,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
