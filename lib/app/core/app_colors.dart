import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:playerhub/app/core/app_shared.dart';

mixin AppColors on GetxController {
  static ThemeMode get themeData =>
      AppShared.darkModeValue.value ? ThemeMode.dark : ThemeMode.light;
  static Brightness get brightnessData =>
      AppShared.darkModeValue.value ? Brightness.light : Brightness.dark;

  static Color get background =>
      AppShared.darkModeValue.value ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get onBackground =>
      AppShared.darkModeValue.value ? const Color(0xFFCCCCCC) : const Color(0xFF333333);
  static Color get surface =>
      AppShared.darkModeValue.value ? const Color(0xFF1F212C) : const Color(0xFFE0DED3);
  static Color get text =>
      AppShared.darkModeValue.value ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color get textGray =>
      AppShared.darkModeValue.value ? const Color(0xFFDDDDDD) : const Color(0xFF222222);
  static Color get primary =>
      AppShared.darkModeValue.value ? const Color(0xFF007AFF) : const Color(0xFF3FA7FE);
}
