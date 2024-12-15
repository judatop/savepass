import 'package:atomic_design_system/molecules/button/ads_filled_round_icon_button.dart';
import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:atomic_design_system/molecules/text/ads_subtitle.dart';
import 'package:atomic_design_system/molecules/text/ads_title.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LastCardsWidget extends StatelessWidget {
  const LastCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Column(
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
              onPressedCallback: () {},
            ),
            const SizedBox(
              width: 10,
            ),
            const AdsTitle(
              text: 'Cards',
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(
          height: deviceHeight * 0.02,
        ),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 0.7,
            aspectRatio: 2.0,
          ),
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return AdsCard(
                  child: Container(
                    color: colorScheme.primary.withOpacity(0.1),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AdsSubtitle(text: 'Visa'),
                              SizedBox(
                                width: deviceWidth * 0.02,
                              ),
                              const Icon(Icons.credit_card),
                            ],
                          ),
                          SizedBox(
                            height: deviceHeight * 0.02,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1234 **** **** 0120',
                              ),
                              Text(
                                'John Doe',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
