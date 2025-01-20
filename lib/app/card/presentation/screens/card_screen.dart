import 'package:animate_do/animate_do.dart';
import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/card/presentation/widgets/card_action_buttons_widget.dart';
import 'package:savepass/app/card/presentation/widgets/card_header_widget.dart';
import 'package:savepass/app/card/presentation/widgets/card_widget.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return AdsScreenTemplate(
      resizeToAvoidBottomInset: false,
      goBack: false,
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                right:
                    deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
                bottom:
                    deviceHeight * ADSFoundationSizes.defaultVerticalPadding,
              ),
              child: Column(
                children: [
                  const CardHeaderWidget(),
                  SizedBox(height: deviceHeight * 0.05),
                  FlipInY(
                    duration: const Duration(seconds: 2),
                    child: const CardWidget(),
                  ),
                  SizedBox(height: deviceHeight * 0.9),
                ],
              ),
            ),
          ),
          const CardActionButtonsWidget(),
        ],
      ),
    );
  }
}
