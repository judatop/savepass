import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/sign_in/presentation/widgets/sign_in_footer_widget.dart';
import 'package:savepass/app/sign_in/presentation/widgets/sign_in_options_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: AdsScreenTemplate(
        wrapScroll: false,
        safeAreaBottom: false,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * ADSFoundationSizes.defaultHorizontalPadding,
                right:
                    screenWidth * ADSFoundationSizes.defaultHorizontalPadding,
              ),
              child: const SignInOptionsWidget(),
            ),
            const SignInFooterWidget(),
          ],
        ),
      ),
    );
  }
}
