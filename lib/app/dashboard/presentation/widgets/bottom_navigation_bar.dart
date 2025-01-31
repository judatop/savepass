import 'dart:io';

import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:savepass/app/dashboard/presentation/widgets/bottom_navigation_bar_icon.dart';

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
        padding: const EdgeInsets.fromLTRB(
          15,
          0,
          15,
          25,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(ADSFoundationSizes.radiusCard),
          color: Colors.transparent,
          elevation: 5,
          child: Container(
            width: deviceWidth,
            height: blockSizeHorizontal * (Platform.isAndroid ? 18 : 17),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius:
                  BorderRadius.circular(ADSFoundationSizes.radiusCard),
            ),
            child: BlocBuilder<DashboardBloc, DashboardState>(
              buildWhen: (previous, current) =>
                  previous.model.currentIndex != current.model.currentIndex,
              builder: (context, state) {
                final index = state.model.currentIndex;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BottomNavigationBarIcon(
                      icon: Icons.home,
                      color:
                          index == 0 ? ADSFoundationsColors.whiteColor : null,
                      index: 0,
                    ),
                    BottomNavigationBarIcon(
                      icon: Icons.apps,
                      color:
                          index == 1 ? ADSFoundationsColors.whiteColor : null,
                      index: 1,
                    ),
                    BottomNavigationBarIcon(
                      icon: Icons.person_4,
                      color:
                          index == 2 ? ADSFoundationsColors.whiteColor : null,
                      index: 2,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
