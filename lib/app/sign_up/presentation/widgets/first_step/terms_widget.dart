import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/core/config/routes.dart';

class TermsWidget extends StatelessWidget {
  const TermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'By joining, you agree to our ',
          style: textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Modular.to.pushNamed(Routes.privacyPolicyRoute),
            ),
          ],
        ),
      ),
    );
  }
}
