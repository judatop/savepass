import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/card/infrastructure/models/card_type.dart';
import 'package:savepass/app/card/presentation/widgets/copy_card_value_bottom_sheet_widget.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/app/dashboard/presentation/widgets/home/no_cards_widget.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/image/image_paths.dart';
import 'package:savepass/core/utils/password_utils.dart';
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
                    onPressedCallback: () => bloc.add(const OnClickNewCard()),
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
                                    child: CopyCardValueBottomSheetWidget(
                                      status: cardStatus,
                                      card: card,
                                    ),
                                  );
                                },
                              );
                            },
                            onTap: () {
                              Modular.to.pushNamed(
                                Routes.cardRoute,
                                arguments: card.id,
                              );
                            },
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
                                      card.type ?? intl.card,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontSize: 19.5,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  card.imgUrl != null
                                      ? CachedNetworkImage(
                                          imageUrl: card.imgUrl!,
                                          width: deviceWidth *
                                              (card.type ==
                                                      CardType.dinersClub
                                                          .stringValue
                                                  ? 0.08
                                                  : 0.12),
                                          placeholder: (context, url) =>
                                              Skeletonizer(
                                            child: Container(
                                              width: 20,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : Image.asset(
                                          ImagePaths.chipImage,
                                          width: deviceWidth * 0.10,
                                        ),
                                  SizedBox(
                                    height: deviceHeight * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        PasswordUtils.formatCard(
                                          card.card.split('|').first,
                                        ),
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          wordSpacing: deviceWidth * 0.025,
                                          fontSize: 14.5,
                                        ),
                                      ),
                                      Text(
                                        card.card.split('|')[1],
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
