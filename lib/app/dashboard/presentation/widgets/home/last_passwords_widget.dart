import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savepass/core/image/image_paths.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class LastPasswordsWidget extends StatelessWidget {
  const LastPasswordsWidget({super.key});

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
              text: 'Passwords',
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
            aspectRatio: 3.0,
          ),
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return AdsCard(
                  onLongPress: () {
                    SnackBarUtils.showSuccessSnackBar(
                      context,
                      'Password copied to clipboard',
                    );
                  },
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // SvgPicture.asset(
                              //   ImagePaths.youtubeImg,
                              //   width: deviceWidth * 0.005,
                              //   height: deviceHeight * 0.03,
                              // ),
                              SizedBox(
                                width: deviceWidth * 0.02,
                              ),
                              const AdsSubtitle(text: 'Youtube'),
                            ],
                          ),
                          SizedBox(
                            height: deviceHeight * 0.015,
                          ),
                          const Text(
                            'judagarcia@outlook.com',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.005,
                          ),
                          const Text(
                            '********',
                            style: TextStyle(
                              fontSize: 15,
                            ),
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
