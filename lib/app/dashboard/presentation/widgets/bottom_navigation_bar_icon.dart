import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:savepass/app/dashboard/presentation/blocs/dashboard_event.dart';

class BottomNavigationBarIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;
  final int index;

  const BottomNavigationBarIcon({
    super.key,
    required this.icon,
    this.color,
    this.size,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final blockSizeHorizontal = deviceWidth / 100;

    return InkWell(
      onTap: () {
        final bloc = Modular.get<DashboardBloc>();
        bloc.add(ChangeIndexEvent(index: index));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: blockSizeHorizontal * 4,
        ),
        child: Icon(
          icon,
          color:
              color ?? ADSFoundationsColors.disabledBackground.withOpacity(.4),
          size: ADSFoundationSizes.sizeIconMedium,
        ),
      ),
    );
  }
}
