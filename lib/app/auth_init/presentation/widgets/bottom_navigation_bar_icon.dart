import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;

  const BottomNavigationBarIcon({
    super.key,
    required this.icon,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Icon(
        icon,
        color: color ?? ADSFoundationsColors.disabledBackground.withOpacity(.4),
        size: size,
      ),
    );
  }
}
