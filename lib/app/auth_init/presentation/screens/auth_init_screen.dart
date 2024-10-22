import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:local_auth/local_auth.dart';
import 'package:savepass/core/config/routes.dart';

class AuthInitScreen extends StatefulWidget {
  const AuthInitScreen({super.key});

  @override
  State<AuthInitScreen> createState() => _AuthInitScreenState();
}

class _AuthInitScreenState extends State<AuthInitScreen> {
  @override
  void initState() {
    _openBiometrics();
    super.initState();
  }

  void _openBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();

    final bool isDeviceSupported = await auth.isDeviceSupported();

    bool isAuthenticated = false;

    if (isDeviceSupported) {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      if (canAuthenticate) {
        isAuthenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(biometricOnly: true),
        );
      } else {
        isAuthenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
        );
      }
    } else {}

    if (isAuthenticated) {
      Modular.to.navigate(Routes.homeRoute);
    }
  }

  void validateMasterPassword() {}

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final deviceHeight = MediaQuery.of(context).size.height;
    final user = FirebaseAuth.instance.currentUser;

    return AdsScreenTemplate(
      wrapScroll: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          AdsHeadline(
            text: '${appLocalizations.authMethodTitle} ${user?.displayName}',
          ),
          SizedBox(height: deviceHeight * 0.02),
          Text(
            Platform.isAndroid
                ? appLocalizations.authMethodAndroidText
                : appLocalizations.authMethodIosText,
          ),
          SizedBox(height: deviceHeight * 0.05),
          AdsFilledIconButton(
            onPressedCallback: _openBiometrics,
            text: 'Authenticate',
            icon: Icons.face_unlock_outlined,
            iconColor: ADSFoundationsColors.whiteColor,
          ),
        ],
      ),
    );
  }
}
