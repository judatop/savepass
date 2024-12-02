import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/main.dart';

class LogOutSettingsWidget extends StatelessWidget {
  const LogOutSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: AdsTextButton(
          text: 'Log Out',
          onPressedCallback: () async {
            await supabase.auth.signOut();
            Modular.to.pushNamedAndRemoveUntil(
              Routes.getStartedRoute,
              (route) => false,
            );
          },
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
