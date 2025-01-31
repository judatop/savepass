import 'package:atomic_design_system/foundations/ads_foundations_colors.dart';
import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:flutter/material.dart';

class PasswordsWidget extends StatelessWidget {
  const PasswordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return AdsCard(
      onTap: () {},
      elevation: 1,
      bgColor: ADSFoundationsColors.primaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.04,
          vertical: deviceHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '12',
                  style: theme.textTheme.displayMedium
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  'passwords',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 17.5,
                  ),
                ),
                SizedBox(height: deviceHeight * 0.01),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: deviceWidth * 0.015),
                const Icon(
                  Icons.trending_flat,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
