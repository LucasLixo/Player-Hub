import 'dart:ui';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:flutter/src/material/app.dart';

mixin AppColors on GetxController {
  static ThemeMode get themeData =>
      AppShared.darkModeValue.value ? ThemeMode.dark : ThemeMode.light;

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
      AppShared.darkModeValue.value ? const Color(0xFF3fa7fe) : const Color(0xFF007AFF);
}
