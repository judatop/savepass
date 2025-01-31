import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/infrastructure/models/card_type.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/app/dashboard/presentation/widgets/home/no_cards_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LastCardsWidget extends StatelessWidget {
  const LastCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final intl = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final bloc = Modular.get<DashboardBloc>();

    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          (previous.model.cards != current.model.cards) ||
          (previous.model.cardStatus != current.model.cardStatus),
      builder: (context, state) {
        final cardStatus = state.model.cardStatus;

        return Skeletonizer(
          enabled: cardStatus.isInProgress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AdsFilledRoundIconButton(
                    backgroundColor: colorScheme.primary,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressedCallback: () {
                      Modular.to.pushNamed(Routes.cardRoute);
                    },
                    tooltip: intl.toolTipAddCard,
                  ),
                  SizedBox(width: deviceWidth * 0.04),
                  AdsTitle(
                    text: intl.cardsTitle,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                buildWhen: (previous, current) =>
                    (previous.model.cards != current.model.cards) ||
                    (previous.model.statusCardValue !=
                        current.model.statusCardValue),
                builder: (context, state) {
                  final list = state.model.cards;
                  final status = state.model.statusCardValue;

                  if (list.isEmpty) {
                    return const NoCardsWidget();
                  }

                  return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.7,
                      aspectRatio: 2.0,
                      enableInfiniteScroll: false,
                    ),
                    items: list.map((card) {
                      return Builder(
                        builder: (BuildContext context) {
                          return AdsCard(
                            onLongPress: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: deviceHeight * 0.70,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: deviceHeight * 0.01,
                                          right: deviceWidth * 0.04,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: TextButton(
                                              onPressed: () => Modular.to.pop(),
                                              child: const Text(
                                                'Cerrar',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: deviceWidth * 0.04,
                                            vertical: deviceHeight * 0.08,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Skeletonizer(
                                              enabled: status.isInProgress,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: deviceHeight * 0.01,
                                                  ),
                                                  const Text(
                                                    'Presiona el valor que deseas copiar:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceHeight * 0.03,
                                                  ),
                                                  ListTile(
                                                    onTap: () {
                                                      Modular.to.pop();
                                                      bloc.add(
                                                        GetCardValueEvent(
                                                          vaultId: card.vaultId,
                                                          index: 1,
                                                        ),
                                                      );
                                                    },
                                                    title: const Text(
                                                      'Card Number',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    leading: const Icon(
                                                      Icons.numbers,
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  ListTile(
                                                    onTap: () {
                                                      Modular.to.pop();
                                                      bloc.add(
                                                        GetCardValueEvent(
                                                          vaultId: card.vaultId,
                                                          index: 2,
                                                        ),
                                                      );
                                                    },
                                                    title: const Text(
                                                      'Card Holdername',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    leading: const Icon(
                                                      Icons.person,
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  ListTile(
                                                    onTap: () {
                                                      Modular.to.pop();
                                                      bloc.add(
                                                        GetCardValueEvent(
                                                          vaultId: card.vaultId,
                                                          index: 3,
                                                        ),
                                                      );
                                                    },
                                                    title: const Text(
                                                      'Expiration',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    leading: const Icon(
                                                      Icons.date_range,
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  ListTile(
                                                    onTap: () {
                                                      Modular.to.pop();
                                                      bloc.add(
                                                        GetCardValueEvent(
                                                          vaultId: card.vaultId,
                                                          index: 4,
                                                        ),
                                                      );
                                                    },
                                                    title: const Text(
                                                      'CVV',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    leading: const Icon(
                                                      Icons.security,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth * 0.05,
                                vertical: deviceHeight * 0.02,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      card.type,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontSize: 19.5,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: card.url,
                                    width: deviceWidth *
                                        (card.type ==
                                                CardType.dinersClub.stringValue
                                            ? 0.08
                                            : 0.12),
                                    placeholder: (context, url) => Skeletonizer(
                                      child: Container(
                                        width: 20,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.cardNumber,
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          wordSpacing: deviceWidth * 0.025,
                                          fontSize: 14.5,
                                        ),
                                      ),
                                      Text(
                                        card.cardHolderName,
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          wordSpacing: deviceWidth * 0.01,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
