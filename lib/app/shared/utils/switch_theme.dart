import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

SwitchThemeData getSwitchTheme() {
  return SwitchThemeData(
    trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.textGray;
      },
    ),
    thumbColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.text;
        }
        return AppColors.background;
      },
    ),
    trackColor:
        WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.textGray;
    }),
  );
}
