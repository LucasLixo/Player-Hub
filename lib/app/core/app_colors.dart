import 'package:flutter/material.dart';
import 'package:playerhub/app/core/app_shared.dart';

class AppColors {
  final ThemeMode themeMode;
  final Brightness brightness;
  final Color background;
  // final Color backgroundOpacity;
  final Color onBackground;
  final Color surface;
  final Color text;
  // final Color textOpacity;
  final Color textGray;
  final Color primary;
  final Color error;
  final Color none;

  AppColors({
    required this.themeMode,
    required this.brightness,
    required this.background,
    // required this.backgroundOpacity,
    required this.onBackground,
    required this.surface,
    required this.text,
    // required this.textOpacity,
    required this.textGray,
    required this.primary,
    required this.error,
    required this.none,
  });

  // Theme current
  factory AppColors.current() {
    return AppShared.darkModeValue.value ? AppColors.dark() : AppColors.light();
  }

  // Theme dark
  factory AppColors.dark() {
    return AppColors(
      themeMode: ThemeMode.dark,
      brightness: Brightness.light,
      background: const Color(0xFF000000),
      // backgroundOpacity: const Color(0x80000000),
      onBackground: const Color(0xFFCCCCCC),
      surface: const Color(0xFF1F212C),
      text: const Color(0xFFFFFFFF),
      // textOpacity: const Color(0x80FFFFFF),
      textGray: const Color(0xFFDDDDDD),
      primary: const Color(0xFF007AFF),
      error: const Color(0xFFFF003D),
      none: const Color(0x00000000),
    );
  }

  // Theme light
  factory AppColors.light() {
    return AppColors(
      themeMode: ThemeMode.light,
      brightness: Brightness.dark,
      background: const Color(0xFFFFFFFF),
      // backgroundOpacity: const Color(0x80FFFFFF),
      onBackground: const Color(0xFF333333),
      surface: const Color(0xFFE0DED3),
      text: const Color(0xFF000000),
      // textOpacity: const Color(0x80000000),
      textGray: const Color(0xFF222222),
      primary: const Color(0xFF3FA7FE),
      error: const Color(0xFFA30027),
      none: const Color(0x00000000),
    );
  }
}
