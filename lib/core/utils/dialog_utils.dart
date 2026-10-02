import 'package:atomic_design_system/atomic_design_system.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  /// Confirm button of an [AlertDialog]. Only padding is overridden: lowering
  /// density or tap target size drops it below Material's 48dp minimum.
  static final confirmButtonStyle = ButtonStyle(
    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  );

  static const confirmButtonIconSize = ADSFoundationSizes.sizeIconSmall;
}
