import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class CardsWidget extends StatelessWidget {
  const CardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return AdsCard(
      onTap: () {},
      elevation: 1,
      bgColor: Colors.green,
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
                  '3',
                  style: theme.textTheme.displayMedium
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  'cards',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 19,
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
