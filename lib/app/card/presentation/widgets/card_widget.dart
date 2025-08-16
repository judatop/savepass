import 'package:animate_do/animate_do.dart';
import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/infrastructure/models/card_type.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_bloc.dart';
import 'package:savepass/app/card/presentation/blocs/card/card_state.dart';
import 'package:savepass/app/card/utils/card_utils.dart';
import 'package:savepass/core/image/image_paths.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:savepass/l10n/app_localizations.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final intl = AppLocalizations.of(context)!;

    return AdsCard(
      elevation: 1.5,
      bgColor: colorScheme.primary.withOpacity(0.8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.05,
          vertical: deviceHeight * 0.02,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<CardBloc, CardState>(
                  buildWhen: (previous, current) =>
                      (previous.model.cardType != current.model.cardType) ||
                      ((previous.model.cardNumber != current.model.cardNumber)),
                  builder: (context, state) {
                    final cardType = state.model.cardType;
                    final cardNumber = state.model.cardNumber.value;

                    TextAlign? textAlign;
                    if (cardType == CardType.americanExpress) {
                      textAlign = TextAlign.center;
                    }

                    if (cardType == CardType.unknown && cardNumber.isNotEmpty) {
                      return Container();
                    }

                    return Skeletonizer(
                      enabled: cardNumber.isEmpty,
                      child: Text(
                        cardType.stringValue,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                        textAlign: textAlign ?? TextAlign.start,
                      ),
                    );
                  },
                ),
                SizedBox(height: deviceHeight * 0.01),
                Row(
                  children: [
                    Skeletonizer(
                      enabled: false,
                      child: Image.asset(
                        ImagePaths.chipImage,
                        height: deviceHeight * 0.06,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: deviceHeight * 0.01),
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
                              ? 'XXXX XXXX XXXX XXXX'
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
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                        final expirationYear = state.model.expirationYear.value;

                        return Skeletonizer(
                          enabled: expirationMonth.isEmpty,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    intl.cardValid,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    intl.cardUntil,
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
                                      ? 'XX/XX'
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
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: BlocBuilder<CardBloc, CardState>(
                buildWhen: (previous, current) =>
                    (previous.model.cardImgSelected !=
                        current.model.cardImgSelected) ||
                    (previous.model.cardType != current.model.cardType),
                builder: (context, state) {
                  final cardImgSelected = state.model.cardImgSelected;
                  final cardType = state.model.cardType;

                  if (cardImgSelected == null || cardType == CardType.unknown) {
                    return Container();
                  }

                  return CachedNetworkImage(
                    imageUrl: cardImgSelected.imgUrl,
                    width: deviceWidth *
                        (cardImgSelected.type == CardType.dinersClub.stringValue
                            ? 0.08
                            : 0.12),
                    placeholder: (context, url) => Skeletonizer(
                      child: Container(
                        width: 20,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                },
              ),
            ),
            BlocBuilder<CardBloc, CardState>(
              buildWhen: (previous, current) =>
                  (previous.model.cardType != current.model.cardType) ||
                  (previous.model.status != current.model.status),
              builder: (context, state) {
                final cardType = state.model.cardType;
                final status = state.model.status;

                if (cardType != CardType.americanExpress ||
                    status.isInProgress) {
                  return Container();
                }

                return Positioned.fill(
                  child: Opacity(
                    opacity: 0.2,
                    child: Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.05),
                      child: Image.asset(
                        ImagePaths.americanExpressFaceImage,
                        width: deviceWidth * 0.35,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
