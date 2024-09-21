import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:playerhub/app/core/app_shared.dart';

// App Colors and Theme
mixin AppColors on GetxController {
  static final ThemeData themeData = ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primary,
      selectionColor: primary,
      selectionHandleColor: surface,
    ),
    sliderTheme: _getSliderTheme(),
    switchTheme: _getSwitchTheme(),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: text,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      displayMedium: TextStyle(
        color: text,
        fontSize: 32,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      displaySmall: TextStyle(
        color: text,
        fontSize: 32,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      headlineLarge: TextStyle(
        color: text,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      headlineMedium: TextStyle(
        color: text,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      headlineSmall: TextStyle(
        color: text,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      titleLarge: TextStyle(
        color: text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      titleMedium: TextStyle(
        color: text,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      titleSmall: TextStyle(
        color: text,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      bodyLarge: TextStyle(
        color: text,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      bodyMedium: TextStyle(
        color: text,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      bodySmall: TextStyle(
        color: text,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      labelLarge: TextStyle(
        color: text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      labelMedium: TextStyle(
        color: text,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      labelSmall: TextStyle(
        color: text,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
    ),
  );

  static ThemeMode get themeMode =>
      AppShared.darkModeValue.value ? ThemeMode.dark : ThemeMode.light;

  static Brightness get brightnessData =>
      AppShared.darkModeValue.value ? Brightness.light : Brightness.dark;

  // Colors based on theme mode
  static Color get background => AppShared.darkModeValue.value
      ? const Color(0xFF000000)
      : const Color(0xFFFFFFFF);
  static Color get onBackground => AppShared.darkModeValue.value
      ? const Color(0xFFCCCCCC)
      : const Color(0xFF333333);
  static Color get surface => AppShared.darkModeValue.value
      ? const Color(0xFF1F212C)
      : const Color(0xFFE0DED3);
  static Color get text => AppShared.darkModeValue.value
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF000000);
  static Color get textGray => AppShared.darkModeValue.value
      ? const Color(0xFFDDDDDD)
      : const Color(0xFF222222);
  static Color get primary => AppShared.darkModeValue.value
      ? const Color(0xFF007AFF)
      : const Color(0xFF3FA7FE);
  static Color get error => AppShared.darkModeValue.value
      ? const Color(0xFFFF003D)
      : const Color(0xFFA30027);
}

// Slider theme customization
SliderThemeData _getSliderTheme() {
  return SliderThemeData(
    trackShape: const _CustomSliderTrackShape(),
    trackHeight: 3.0,
    inactiveTrackColor: AppColors.onBackground,
    inactiveTickMarkColor: AppColors.onBackground,
  );
}

// Custom slider track shape
class _CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const _CustomSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

// Switch theme customization
SwitchThemeData _getSwitchTheme() {
  return SwitchThemeData(
    trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? AppColors.primary
          : AppColors.textGray,
    ),
    thumbColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? AppColors.text
          : AppColors.background,
    ),
    trackColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) => states.contains(WidgetState.selected)
          ? AppColors.primary
          : AppColors.textGray,
    ),
  );
}
