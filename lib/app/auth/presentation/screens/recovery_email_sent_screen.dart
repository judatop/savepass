import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:savepass/app/auth/presentation/widgets/forgot_password/recovery_email_header.dart';
import 'package:savepass/core/lottie/lottie_paths.dart';

class RecoveryEmailSentScreen extends StatelessWidget {
  const RecoveryEmailSentScreen({super.key});

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
              const RecoveryEmailHeader(),
              SizedBox(height: deviceHeight * 0.06),
              AdsHeadline(text: intl.checkYourMailTitle),
              SizedBox(height: deviceHeight * 0.03),
              Lottie.asset(
                width: deviceWidth * 0.5,
                LottiePaths.mail,
              ),
              Text(
                intl.recoveryPasswordSent,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
