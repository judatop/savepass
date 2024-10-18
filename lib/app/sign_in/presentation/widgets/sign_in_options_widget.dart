import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInOptionsWidget extends StatelessWidget {
  const SignInOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final appLocalizations = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
        right: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          AdsHeadline(text: appLocalizations.authTitle),
          SizedBox(height: deviceHeight * 0.02),
        ],
      ),
    );
  }
}
