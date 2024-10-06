import 'package:flutter/material.dart';
import 'package:playerhub/app/core/app_colors.dart';

abstract class ThemeMaterial {
  // Retorna o tema claro
  static ThemeData light() {
    return ThemeData(
      brightness: AppColors.light().brightness,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      scaffoldBackgroundColor: AppColors.light().background,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.light().primary,
        selectionColor: AppColors.light().primary,
        selectionHandleColor: AppColors.light().surface,
      ),
      sliderTheme: _getSliderTheme(isDark: false),
      switchTheme: _getSwitchTheme(isDark: false),
      textTheme: _getTextTheme(isDark: false),
      inputDecorationTheme: _getInputDecorationTheme(isDark: false),
    );
  }

  // Retorna o tema escuro
  static ThemeData dark() {
    return ThemeData(
      brightness: AppColors.dark().brightness,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      scaffoldBackgroundColor: AppColors.dark().background,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.dark().primary,
        selectionColor: AppColors.dark().primary,
        selectionHandleColor: AppColors.dark().surface,
      ),
      sliderTheme: _getSliderTheme(isDark: true),
      switchTheme: _getSwitchTheme(isDark: true),
      textTheme: _getTextTheme(isDark: true),
      inputDecorationTheme: _getInputDecorationTheme(isDark: true),
    );
  }

  // Tema compartilhado para Slider
  static SliderThemeData _getSliderTheme({required bool isDark}) {
    return SliderThemeData(
      trackShape: const _CustomSliderTrackShape(),
      trackHeight: 3.0,
      inactiveTrackColor: isDark
          ? AppColors.dark().onBackground
          : AppColors.light().onBackground,
      inactiveTickMarkColor: isDark
          ? AppColors.dark().onBackground
          : AppColors.light().onBackground,
    );
  }

  // Tema compartilhado para Switch
  static SwitchThemeData _getSwitchTheme({required bool isDark}) {
    return SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? (isDark ? AppColors.dark().primary : AppColors.light().primary)
              : (isDark
                  ? AppColors.dark().textGray
                  : AppColors.light().textGray)),
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => states.contains(WidgetState.selected)
            ? (isDark ? AppColors.dark().text : AppColors.light().text)
            : (isDark
                ? AppColors.dark().background
                : AppColors.light().background),
      ),
    );
  }

  // Tema compartilhado para Textos
  static TextTheme _getTextTheme({required bool isDark}) {
    return TextTheme(
      displayLarge: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      displayMedium: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 32,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      displaySmall: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 32,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      headlineLarge: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      headlineMedium: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      headlineSmall: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      titleLarge: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      titleMedium: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      titleSmall: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      bodyLarge: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      bodyMedium: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      bodySmall: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      labelLarge: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      labelMedium: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      labelSmall: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
    );
  }

  static InputDecorationTheme _getInputDecorationTheme({required bool isDark}) {
    return InputDecorationTheme(
      labelStyle: TextStyle(
        color: isDark ? AppColors.dark().text : AppColors.light().text,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      floatingLabelStyle: TextStyle(
        color: isDark ? AppColors.dark().primary : AppColors.light().primary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      hintStyle: TextStyle(
        color: isDark ? AppColors.dark().textGray : AppColors.light().textGray,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      errorStyle: TextStyle(
        color: isDark ? AppColors.dark().error : AppColors.light().error,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
  }
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
    final trackHeight = sliderTheme.trackHeight ?? 2.0;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
