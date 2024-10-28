import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_bloc.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/auth_utils.dart';

class SignInOptionsWidget extends StatelessWidget {
  const SignInOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;
    final bloc = Modular.get<SignInBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AuthUtils.googleButtonsColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(
              ADSFoundationSizes.radiusFormItem,
            ),
          ),
          child: AdsFilledIconButton(
            onPressedCallback: () => bloc.add(const SignInWithGoogleEvent()),
            text:
                '${appLocalizations.getStartedSingIn} ${appLocalizations.authWithGoogle}',
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
          text:
              '${appLocalizations.getStartedSingIn} ${appLocalizations.authWithApple}',
          icon: Icons.apple,
          iconSize: ADSFoundationSizes.sizeIconMedium,
          iconColor: colorScheme.brightness == Brightness.light
              ? ADSFoundationsColors.whiteColor
              : ADSFoundationsColors.blackColor,
          buttonStyle: ButtonStyle(
            backgroundColor: colorScheme.brightness == Brightness.light
                ? WidgetStateProperty.all(
                    ADSFoundationsColors.blackColor,
                  )
                : WidgetStateProperty.all(
                    ADSFoundationsColors.whiteColor,
                  ),
            overlayColor: colorScheme.brightness == Brightness.light
                ? WidgetStateProperty.all(
                    Colors.red.withOpacity(0.4),
                  )
                : WidgetStateProperty.all(
                    Colors.red.withOpacity(0.2),
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
          onPressedCallback: () => bloc.add(const SignInWithGithubEvent()),
          text:
              '${appLocalizations.getStartedSingIn} ${appLocalizations.authWithGithub}',
          buttonStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              const Color(0xFF136AFF),
            ),
          ),
          icon: Icons.library_books,
          iconSize: ADSFoundationSizes.sizeIconMedium,
          iconColor: ADSFoundationsColors.whiteColor,
        ),
        SizedBox(height: deviceHeight * 0.025),
        const Divider(),
        SizedBox(height: deviceHeight * 0.025),
        AdsOutlinedIconButton(
          onPressedCallback: () => Modular.to.pushNamed(Routes.signInEmail),
          text:
              '${appLocalizations.getStartedSingIn} ${appLocalizations.authEmail}',
          icon: Icons.email,
          iconSize: ADSFoundationSizes.sizeIconMedium,
        ),
      ],
    );
  }
}
