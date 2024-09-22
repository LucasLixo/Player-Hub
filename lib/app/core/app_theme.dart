import 'package:flutter/material.dart';
import 'package:playerhub/app/core/app_colors.dart';

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  scaffoldBackgroundColor: AppColors.lightBackground,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.lightPrimary,
    selectionColor: AppColors.lightPrimary,
    selectionHandleColor: AppColors.lightSurface,
  ),
  sliderTheme: _getSliderTheme(isDark: false),
  switchTheme: _getSwitchTheme(isDark: false),
  textTheme: _getTextTheme(isDark: false),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  hoverColor: Colors.transparent,
  scaffoldBackgroundColor: AppColors.darkBackground,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.darkPrimary,
    selectionColor: AppColors.darkPrimary,
    selectionHandleColor: AppColors.darkSurface,
  ),
  sliderTheme: _getSliderTheme(isDark: true),
  switchTheme: _getSwitchTheme(isDark: true),
  textTheme: _getTextTheme(isDark: true),
);

// Shared Slider theme customization
SliderThemeData _getSliderTheme({required bool isDark}) {
  return SliderThemeData(
    trackShape: const _CustomSliderTrackShape(),
    trackHeight: 3.0,
    inactiveTrackColor:
        isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
    inactiveTickMarkColor:
        isDark ? AppColors.darkOnBackground : AppColors.lightOnBackground,
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

// Shared Switch theme customization
SwitchThemeData _getSwitchTheme({required bool isDark}) {
  return SwitchThemeData(
    trackOutlineColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) => states.contains(MaterialState.selected)
          ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
          : AppColors.lightTextGray,
    ),
    thumbColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) => states.contains(MaterialState.selected)
          ? (isDark ? AppColors.darkText : AppColors.lightText)
          : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
    ),
    trackColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) => states.contains(MaterialState.selected)
          ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
          : AppColors.lightTextGray,
    ),
  );
}

// Shared Text theme customization
TextTheme _getTextTheme({required bool isDark}) {
  return TextTheme(
    displayLarge: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    displayMedium: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 32,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    displaySmall: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 32,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontFamily: 'OpenSans',
    ),
    headlineLarge: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    headlineMedium: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    headlineSmall: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontFamily: 'OpenSans',
    ),
    titleLarge: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    titleMedium: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 18,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    titleSmall: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 18,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontFamily: 'OpenSans',
    ),
    bodyLarge: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    bodyMedium: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    bodySmall: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontFamily: 'OpenSans',
    ),
    labelLarge: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    labelMedium: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontFamily: 'OpenSans',
    ),
    labelSmall: TextStyle(
      color: isDark ? AppColors.darkText : AppColors.lightText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontFamily: 'OpenSans',
    ),
  );
}
