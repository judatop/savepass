import 'package:atomic_design_system/molecules/card/ads_card.dart';
import 'package:flutter/material.dart';

class JoinBiometricsWidget extends StatelessWidget {
  const JoinBiometricsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return AdsCard(
      onTap: () {},
      bgColor: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.face,
            color: Colors.white,
          ),
          SizedBox(width: deviceWidth * 0.02),
          Text(
            'Join with biometrics',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: 19.5,
            ),
          ),
        ],
      ),
    );
  }
}
