import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return AdsScreenTemplate(
      wrapScroll: false,
      padding: EdgeInsets.zero,
      safeAreaBottom: false,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const AdsHeadline(text: 'Sign in to SavePass'),
              SizedBox(height: deviceHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AdsFilledIconButton(
                      onPressedCallback: () {},
                      text: 'Continue with Google',
                      icon: Icons.g_mobiledata,
                      iconSize: ADSFoundationSizes.sizeIconMedium,
                      iconColor: ADSFoundationsColors.whiteColor,
                    ),
                    SizedBox(height: deviceHeight * 0.01),
                    AdsFilledIconButton(
                      onPressedCallback: () {},
                      text: 'Continue with Apple ID',
                      icon: Icons.apple,
                      iconSize: ADSFoundationSizes.sizeIconMedium,
                      iconColor: ADSFoundationsColors.whiteColor,
                    ),
                    SizedBox(height: deviceHeight * 0.01),
                    AdsFilledIconButton(
                      onPressedCallback: () {},
                      text: 'Continue with Facebook',
                      buttonStyle: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          colorScheme.primary.withOpacity(.45),
                        ),
                      ),
                      icon: Icons.facebook,
                      iconSize: ADSFoundationSizes.sizeIconMedium,
                      iconColor: ADSFoundationsColors.whiteColor,
                    ),
                    SizedBox(height: deviceHeight * 0.025),
                    const Divider(),
                    SizedBox(height: deviceHeight * 0.025),
                    AdsOutlinedIconButton(
                      onPressedCallback: () {},
                      text: 'Continue with Email',
                      icon: Icons.chevron_right,
                      iconSize: ADSFoundationSizes.sizeIconMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: colorScheme.brightness == Brightness.light
                  ? Colors.transparent
                  : Colors.black,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: Platform.isAndroid
                      ? deviceHeight * 0.01
                      : deviceHeight * 0.03,
                  top: deviceHeight * 0.01,
                ),
                child: Column(
                  children: [
                    if (colorScheme.brightness == Brightness.light)
                      const Divider(),
                    const AdsTextButton(
                      text: 'Don\'t have an account? Sign up',
                      onPressedCallback: null,
                      textStyle: TextStyle(
                        color: Colors.blue,
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
  }
}
