import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/about_app_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/avatar_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/biometric_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/delete_account_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/display_name_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/email_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/language_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/log_out_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/policy_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/terms_settings_widget.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/theme_settings_widget.dart';
import 'package:savepass/l10n/app_localizations.dart';
import 'package:savepass/app/dashboard/presentation/widgets/settings/update_master_password_widget.dart';
import 'package:savepass/main.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    final isAuthWithProvider =
        supabase.auth.currentUser?.appMetadata['provider'] != 'email';

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: (ADSFoundationSizes.defaultVerticalPadding / 2) * deviceHeight,
          left: ADSFoundationSizes.defaultHorizontalPadding * deviceWidth,
          right: ADSFoundationSizes.defaultHorizontalPadding * deviceWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsHeadline(
              text: intl.accountSettings,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: deviceHeight * 0.015),
            const Divider(),
            SizedBox(height: deviceHeight * 0.01),
            const EmailSettingsWidget(),
            SizedBox(height: deviceHeight * 0.02),
            const AvatarSettingsWidget(),
            SizedBox(height: deviceHeight * 0.02),
            if (!isAuthWithProvider)
              Column(
                children: [
                  const DisplayNameWidget(),
                  SizedBox(height: deviceHeight * 0.02),
                ],
              ),
            const ThemeSettingsWidget(),
            SizedBox(height: deviceHeight * 0.02),
            const BiometricSettingsWidget(),
            SizedBox(height: deviceHeight * 0.02),
            const LanguageSettingsWidget(),
            const PolicySettingsWidget(),
            SizedBox(height: deviceHeight * 0.02),
            const TermsSettingsWidget(),
            SizedBox(height: deviceHeight * 0.02),
            const AboutAppSettingsWidget(),
            SizedBox(height: deviceHeight * 0.02),
            const UpdateMasterPasswordWidget(),
            SizedBox(height: deviceHeight * 0.02),
            const DeleteAccountSettingsWidget(),
            SizedBox(height: deviceHeight * 0.02),
            const LogOutSettingsWidget(),
            SizedBox(height: deviceHeight * 0.2),
          ],
        ),
      ),
    );
  }
}
