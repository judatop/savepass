import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/auth/presentation/widgets/auth_email/confirm_mail_header_widget.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';

class ConfirmMailSignUpScreen extends StatelessWidget {
  const ConfirmMailSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return AdsScreenTemplate(
      safeAreaBottom: false,
      safeAreaTop: true,
      wrapScroll: false,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.only(
          left: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
          right: deviceWidth * ADSFoundationSizes.defaultHorizontalPadding,
          bottom: deviceHeight * ADSFoundationSizes.defaultVerticalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ConfirmMailHeaderWidget(),
              SizedBox(height: deviceHeight * 0.06),
              AdsHeadline(text: intl.checkYourMailTitle),
              SizedBox(height: deviceHeight * 0.03),
              Lottie.asset(
                width: deviceWidth * 0.5,
                LottiePaths.mail,
              ),
              Text(
                intl.signUpCheckMailText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
