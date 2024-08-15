import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors extends GetxController {
  static RxBool isDarkMode = true.obs;

  static ThemeMode get themeData =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  static Color get background =>
      isDarkMode.value ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get onBackground =>
      isDarkMode.value ? const Color(0xFFCCCCCC) : const Color(0xFF333333);
  static Color get surface =>
      isDarkMode.value ? const Color(0xFF1F212C) : const Color(0xFFE0DED3);
  static Color get text =>
      isDarkMode.value ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color get textGray =>
      isDarkMode.value ? const Color(0xFFDDDDDD) : const Color(0xFF222222);
  static Color get primary =>
      isDarkMode.value ? const Color(0xFF3fa7fe) : const Color(0xFF007AFF);
}
