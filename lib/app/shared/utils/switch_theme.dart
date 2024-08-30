import 'dart:ui';
import 'package:flutter/src/material/switch_theme.dart';
import 'package:flutter/src/widgets/widget_state.dart';
import 'package:playerhub/app/core/app_colors.dart';

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
