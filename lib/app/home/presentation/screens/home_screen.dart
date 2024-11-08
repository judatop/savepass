import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/auth_init/presentation/widgets/bottom_navigation_bar.dart';
import 'package:savepass/core/config/routes.dart';
import 'package:savepass/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: true,
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
                      onPressedCallback: () async {
                        await supabase.auth.signOut();
                        Modular.to.pushNamedAndRemoveUntil(
                          Routes.getStartedRoute,
                          (route) => false,
                        );
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
