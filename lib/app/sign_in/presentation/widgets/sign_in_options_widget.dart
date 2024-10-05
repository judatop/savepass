import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/core/widgets/auth_options.dart';

class SignInOptionsWidget extends StatelessWidget {
  const SignInOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        AdsHeadline(text: appLocalizations.signInTitle),
        SizedBox(height: deviceHeight * 0.02),
        AuthOptions(
          onTapGoogle: () {},
          onTapApple: () {},
          onTapFacebook: () {},
        ),
      ],
    );
  }
}
