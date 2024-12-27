import 'package:flutter/material.dart';

class ThemeColors {
  final ThemeMode themeMode;
  final Brightness brightness;
  final Color background;
  final Color backgroundOpacity;
  final Color onBackground;
  final Color surface;
  final Color text;
  final Color textOpacity;
  final Color textGray;
  final Color primary;
  final Color error;
  final Color alert;
  final Color success;
  // final Color none;

  ThemeColors({
    required this.themeMode,
    required this.brightness,
    required this.background,
    required this.backgroundOpacity,
    required this.onBackground,
    required this.surface,
    required this.text,
    required this.textOpacity,
    required this.textGray,
    required this.primary,
    required this.error,
    required this.alert,
    required this.success,
    // required this.none,
  });

  // Theme current
  factory ThemeColors.current({bool isDark = false}) {
    return isDark ? ThemeColors.dark() : ThemeColors.light();
  }

  // Theme dark
  factory ThemeColors.dark() {
    return ThemeColors(
      themeMode: ThemeMode.dark,
      brightness: Brightness.light,
      background: const Color(0xFF000000),
      backgroundOpacity: const Color(0x80000000),
      onBackground: const Color(0xFFCCCCCC),
      surface: const Color(0xFF23282c),
      text: const Color(0xFFFFFFFF),
      textOpacity: const Color(0x80FFFFFF),
      textGray: const Color(0xFFDDDDDD),
      primary: const Color(0xFF007AFF),
      error: const Color(0xFFFF003D),
      alert: const Color(0xFFE7E236),
      success: const Color(0xFF40AA5C),
      // none: Colors.transparent,
    );
  }

  // Theme light
  factory ThemeColors.light() {
    return ThemeColors(
      themeMode: ThemeMode.light,
      brightness: Brightness.dark,
      background: const Color(0xFFFFFFFF),
      backgroundOpacity: const Color(0x80FFFFFF),
      onBackground: const Color(0xFF333333),
      surface: const Color(0xFFF6F5F3),
      text: const Color(0xFF000000),
      textOpacity: const Color(0x80000000),
      textGray: const Color(0xFF222222),
      primary: const Color(0xFF3FA7FE),
      error: const Color(0xFFA30027),
      alert: const Color(0xFFE5CB00),
      success: const Color(0xFF228A44),
      // none: Colors.transparent,
    );
  }
}
