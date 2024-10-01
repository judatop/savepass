import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NameTermsWidget extends StatelessWidget {
  const NameTermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By joining, you agree to our ',
        style: textTheme.bodyMedium,
        children: <TextSpan>[
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint('Terms tapped');
              },
          ),
          const TextSpan(
            text: ' and ',
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint('Privacy tapped');
              },
          ),
        ],
      ),
    );
  }
}
