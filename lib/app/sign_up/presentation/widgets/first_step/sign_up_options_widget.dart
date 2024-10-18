import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/utils/auth_utils.dart';

class SignUpOptionsWidget extends StatelessWidget {
  const SignUpOptionsWidget({super.key});

  void signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      debugPrint('googleUser id: ${googleUser?.id}');

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Modular.to.popAndPushNamed(Routes.homeRoute);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void signUpwithGithub() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }

  void signUpWithEmail() {
    Modular.to.pushNamed(Routes.singUpSecondStepRoute);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;

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
            onPressedCallback: signUpWithGoogle,
            text:
                '${appLocalizations.getStartedSingUp} ${appLocalizations.authWithGoogle}',
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
              '${appLocalizations.getStartedSingUp} ${appLocalizations.authWithApple}',
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
          onPressedCallback: signUpwithGithub,
          text:
              '${appLocalizations.getStartedSingUp} ${appLocalizations.authWithGithub}',
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
          onPressedCallback: signUpWithEmail,
          text:
              '${appLocalizations.getStartedSingUp} ${appLocalizations.authEmail}',
          icon: Icons.email,
          iconSize: ADSFoundationSizes.sizeIconMedium,
        ),
      ],
    );
  }
}
