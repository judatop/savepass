import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/core/image/image_paths.dart';

const int splashDuration = 3000;
const double imagePercentageWidth = 0.5;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _timerSplash();
  }

  void _timerSplash() {
    Future.delayed(
      const Duration(milliseconds: splashDuration),
      () {
        // final user = FirebaseAuth.instance.currentUser;

        // if (user != null) {
        //   Modular.to.navigate(Routes.authInitRoute);
        //   return;
        // }

        // Modular.to.navigate(Routes.getStartedRoute);
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ADSFoundationsColors.whiteColor,
      body: Center(
        child: Image.asset(
          ImagePaths.logoLightImage,
          width: screenWidth,
        ),
      ),
    );
  }
}
