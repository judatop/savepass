import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdsScreenTemplate(
      child: Text('Splash Screen'),
    );
  }
}
