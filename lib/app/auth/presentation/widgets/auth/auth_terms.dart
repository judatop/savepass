import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:savepass/app/auth/presentation/blocs/auth_event.dart';

class AuthTerms extends StatelessWidget {
  const AuthTerms({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<AuthBloc>();
    final textTheme = Theme.of(context).textTheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    final appLocalizations = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: '${appLocalizations.byJoiningText} ',
          style: textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(
              text: appLocalizations.privacyPolicy,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => bloc.add(const OpenPrivacyEvent()),
            ),
            TextSpan(
              text: ' ${appLocalizations.and} ',
              style: textTheme.bodyMedium,
            ),
            TextSpan(
              text: appLocalizations.termsTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => bloc.add(const OpenTermsEvent()),
            ),
          ],
        ),
      ),
    );
  }
}
