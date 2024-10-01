import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/sign_in/presentation/widgets/sign_in_footer_widget.dart';
import 'package:savepass/app/sign_in/presentation/widgets/sign_in_options_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return const AdsScreenTemplate(
      wrapScroll: false,
      padding: EdgeInsets.zero,
      safeAreaBottom: false,
      child: Stack(
        children: [
          SignInOptionsWidget(),
          SignInFooterWidget(),
        ],
      ),
    );
  }
}
