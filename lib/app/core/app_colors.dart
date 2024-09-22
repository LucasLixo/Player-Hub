import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:playerhub/app/core/app_shared.dart';

// App Colors and Theme
mixin AppColors on GetxController {
  static ThemeMode get themeMode =>
      AppShared.darkModeValue.value ? ThemeMode.dark : ThemeMode.light;

  static Brightness get brightnessData =>
      AppShared.darkModeValue.value ? Brightness.light : Brightness.dark;

  static Color lightBackground = const Color(0xFF000000);
  static Color darkBackground = const Color(0xFFFFFFFF);
  static Color lightOnBackground = const Color(0xFFCCCCCC);
  static Color darkOnBackground = const Color(0xFF333333);
  static Color lightSurface = const Color(0xFF1F212C);
  static Color darkSurface = const Color(0xFFE0DED3);
  static Color lightText = const Color(0xFFFFFFFF);
  static Color darkText = const Color(0xFF000000);
  static Color lightTextGray = const Color(0xFFDDDDDD);
  static Color darkTextGray = const Color(0xFF222222);
  static Color lightPrimary = const Color(0xFF007AFF);
  static Color darkPrimary = const Color(0xFF3FA7FE);
  static Color lightError = const Color(0xFFFF003D);
  static Color darkError = const Color(0xFFA30027);

  // Colors based on theme mode
  static Color get background =>
      AppShared.darkModeValue.value ? lightBackground : darkBackground;
  static Color get onBackground =>
      AppShared.darkModeValue.value ? lightOnBackground : darkOnBackground;
  static Color get surface =>
      AppShared.darkModeValue.value ? lightSurface : darkSurface;
  static Color get text => AppShared.darkModeValue.value ? lightText : darkText;
  static Color get textGray =>
      AppShared.darkModeValue.value ? lightTextGray : darkTextGray;
  static Color get primary =>
      AppShared.darkModeValue.value ? lightPrimary : darkPrimary;
  static Color get error =>
      AppShared.darkModeValue.value ? lightError : darkError;
}
