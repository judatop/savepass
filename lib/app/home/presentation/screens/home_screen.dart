import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/auth_init/presentation/widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: AdsScreenTemplate(
        safeAreaBottom: false,
        safeAreaTop: false,
        wrapScroll: false,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: SafeArea(
                top: true,
                child: Column(
                  children: [
                    SizedBox(height: deviceHeight * 0.02),
                    const AdsHeadline(
                      text: 'SavePass',
                    ),
                    AdsFilledButton(
                      onPressedCallback: () {
                        FirebaseAuth.instance.signOut();
                      },
                      text: 'Sign Out',
                    ),
                  ],
                ),
              ),
            ),
            const CustomBottomNavigationBar(),
          ],
        ),
      ),
    );
  }
}
