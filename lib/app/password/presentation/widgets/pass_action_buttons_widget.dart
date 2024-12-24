import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class PassActionButtonsWidget extends StatelessWidget {
  const PassActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          if (colorScheme.brightness == Brightness.light) const Divider(),
          Container(
            color: colorScheme.brightness == Brightness.light
                ? Colors.transparent
                : Colors.black,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: screenHeight * (Platform.isAndroid ? 0.01 : 0.05),
                right:
                    screenWidth * ADSFoundationSizes.defaultHorizontalPadding,
                left: screenWidth * ADSFoundationSizes.defaultHorizontalPadding,
              ),
              child: Column(
                children: [
                  if (colorScheme.brightness == Brightness.light)
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AdsFilledIconButton(
                          text: 'Save',
                          onPressedCallback: () => {},
                          icon: Icons.save,
                          iconSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
