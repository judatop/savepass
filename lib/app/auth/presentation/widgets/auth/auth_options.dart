import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savepass/app/auth/infrastructure/models/auth_type.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_state.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/image/image_paths.dart';
import 'package:savepass/core/utils/auth_utils.dart';

class AuthOptions extends StatelessWidget {
  const AuthOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;
    final bloc = Modular.get<AuthBloc>();
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          previous.model.authType != current.model.authType,
      builder: (context, state) {
        final textByAuthType = state.model.authType == AuthType.signIn
            ? appLocalizations.getStartedSingIn
            : appLocalizations.getStartedSingUp;

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
                onPressedCallback: () => bloc.add(const AuthWithGoogleEvent()),
                text: '$textByAuthType ${appLocalizations.authWithGoogle}',
                widget: SvgPicture.asset(
                  ImagePaths.googleLogoImage,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  semanticsLabel: 'Google',
                  width: AuthUtils.imgWidth,
                ),
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.01),
            if (Platform.isIOS)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdsFilledIconButton(
                    onPressedCallback: () =>
                        bloc.add(const AuthWithAppleEvent()),
                    text: '$textByAuthType ${appLocalizations.authWithApple}',
                    icon: Icons.apple,
                    iconSize: ADSFoundationSizes.sizeIconMedium,
                    iconColor: colorScheme.brightness == Brightness.light
                        ? ADSFoundationsColors.whiteColor
                        : ADSFoundationsColors.blackColor,
                    buttonStyle: ButtonStyle(
                      backgroundColor:
                          colorScheme.brightness == Brightness.light
                              ? WidgetStateProperty.all(
                                  ADSFoundationsColors.blackColor,
                                )
                              : WidgetStateProperty.all(
                                  ADSFoundationsColors.whiteColor,
                                ),
                    ),
                    textStyle: TextStyle(
                      color: colorScheme.brightness == Brightness.light
                          ? ADSFoundationsColors.whiteColor
                          : ADSFoundationsColors.blackColor,
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                ],
              ),
            AdsFilledIconButton(
              onPressedCallback: () => bloc.add(const AuthWithGithubEvent()),
              text: '$textByAuthType ${appLocalizations.authWithGithub}',
              buttonStyle: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFF136AFF),
                ),
              ),
              widget: SvgPicture.asset(
                ImagePaths.githubLogoImage,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                semanticsLabel: 'Google',
                width: AuthUtils.imgWidth,
              ),
            ),
            SizedBox(height: deviceHeight * 0.025),
            const Divider(),
            SizedBox(height: deviceHeight * 0.025),
            AdsOutlinedIconButton(
              onPressedCallback: () =>
                  Modular.to.pushNamed(Routes.authEmailRoute),
              text: '$textByAuthType ${appLocalizations.authEmail}',
              icon: Icons.email,
              iconSize: AuthUtils.imgWidth,
            ),
          ],
        );
      },
    );
  }
}
