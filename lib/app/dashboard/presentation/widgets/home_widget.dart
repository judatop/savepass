import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: (ADSFoundationSizes.defaultVerticalPadding / 2) * deviceHeight,
          left: ADSFoundationSizes.defaultHorizontalPadding * deviceWidth,
          right: ADSFoundationSizes.defaultHorizontalPadding * deviceWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdsHeadline(
              text: 'Home',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: deviceHeight * 0.015),
            const Divider(),
            SizedBox(height: deviceHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
