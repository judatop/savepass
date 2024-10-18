import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:savepass/app/auth_init/presentation/widgets/bottom_navigation_bar_icon.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final blockSizeHorizontal = deviceWidth / 100;

    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          blockSizeHorizontal * 4.5,
          0,
          blockSizeHorizontal * 4.5,
          35,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          color: Colors.transparent,
          elevation: 5,
          child: Container(
            width: deviceWidth,
            height: blockSizeHorizontal * 18,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius:
                  BorderRadius.circular(ADSFoundationSizes.radiusCard),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomNavigationBarIcon(
                  icon: Icons.home,
                  color: ADSFoundationsColors.whiteColor,
                ),
                BottomNavigationBarIcon(icon: Icons.apps),
                BottomNavigationBarIcon(icon: Icons.person_4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
