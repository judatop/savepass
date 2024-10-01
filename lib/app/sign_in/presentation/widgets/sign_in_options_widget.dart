import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/sign_in/utils/sign_in_utils.dart';

class SignInOptionsWidget extends StatelessWidget {
  const SignInOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final appLocalizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        AdsHeadline(text: appLocalizations.signInTitle),
        SizedBox(height: deviceHeight * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: SignInUtils.googleButtonColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(
                    ADSFoundationSizes.radiusFormItem,
                  ),
                ),
                child: AdsFilledIconButton(
                  onPressedCallback: () {},
                  text: appLocalizations.signInGoogle,
                  icon: Icons.g_mobiledata,
                  iconSize: ADSFoundationSizes.sizeIconMedium,
                  iconColor: ADSFoundationsColors.whiteColor,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.01),
              AdsFilledIconButton(
                onPressedCallback: () {},
                text: appLocalizations.signInApple,
                icon: Icons.apple,
                iconSize: ADSFoundationSizes.sizeIconMedium,
                iconColor: colorScheme.brightness == Brightness.light
                    ? ADSFoundationsColors.whiteColor
                    : ADSFoundationsColors.blackColor,
                buttonStyle: ButtonStyle(
                  backgroundColor: colorScheme.brightness == Brightness.light
                      ? MaterialStateProperty.all(
                          ADSFoundationsColors.blackColor,
                        )
                      : MaterialStateProperty.all(
                          ADSFoundationsColors.whiteColor,
                        ),
                  overlayColor: colorScheme.brightness == Brightness.light
                      ? MaterialStateProperty.all(
                          Colors.red.withOpacity(0.2),
                        )
                      : MaterialStateProperty.all(
                          Colors.red.withOpacity(0.1),
                        ),
                ),
                textStyle: TextStyle(
                  color: colorScheme.brightness == Brightness.light
                      ? ADSFoundationsColors.whiteColor
                      : ADSFoundationsColors.blackColor,
                ),
              ),
              SizedBox(height: deviceHeight * 0.01),
              AdsFilledIconButton(
                onPressedCallback: () {},
                text: appLocalizations.signInFacebook,
                buttonStyle: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF136AFF),
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
                text: appLocalizations.signInEmail,
                icon: Icons.chevron_right,
                iconSize: ADSFoundationSizes.sizeIconMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
