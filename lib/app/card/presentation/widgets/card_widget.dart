import 'package:animate_do/animate_do.dart';
import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                Skeletonizer(
                  enabled: true,
                  child: Text(
                    'VISA',
                    style:
                        textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.015,
                ),
                Skeletonizer(
                  enabled: true,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeletonizer(
                      enabled: true,
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
                          Text(
                            '05/27',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              wordSpacing: deviceWidth * 0.01,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: deviceWidth * 0.05),
                    Skeletonizer(
                      enabled: true,
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
                          Text(
                            '05/27',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              wordSpacing: deviceWidth * 0.01,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
