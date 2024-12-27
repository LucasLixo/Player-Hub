import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helper_hub/src/theme_colors.dart';

abstract class ThemeMaterial {
  // Retorna o tema claro
  static ThemeData light() {
    return ThemeData(
      dialogBackgroundColor: ThemeColors.light().surface,
      primaryColor: ThemeColors.light().primary,
      brightness: ThemeColors.light().brightness,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      scaffoldBackgroundColor: ThemeColors.light().background,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ThemeColors.light().text,
        selectionColor: ThemeColors.light().primary,
        selectionHandleColor: ThemeColors.light().primary,
      ),
      sliderTheme: _getSliderTheme(isDark: false),
      switchTheme: _getSwitchTheme(isDark: false),
      textTheme: _getTextTheme(isDark: false),
      inputDecorationTheme: _getInputDecorationTheme(isDark: false),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ThemeColors.light().text,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: ThemeColors.light().brightness,
          systemNavigationBarColor: ThemeColors.light().background,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: ThemeColors.light().brightness,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: ThemeColors.light().brightness,
        primary: ThemeColors.light().primary,
        onPrimary: ThemeColors.light().text,
        surface: ThemeColors.light().surface,
        onSurface: ThemeColors.light().text,
        error: ThemeColors.light().error,
        onError: ThemeColors.light().text,
      ),
      iconTheme: IconThemeData(
        color: ThemeColors.light().text,
        size: 28,
      ),
    );
  }

  // Retorna o tema escuro
  static ThemeData dark() {
    return ThemeData(
      dialogBackgroundColor: ThemeColors.dark().surface,
      primaryColor: ThemeColors.dark().primary,
      brightness: ThemeColors.dark().brightness,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      scaffoldBackgroundColor: ThemeColors.dark().background,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ThemeColors.dark().text,
        selectionColor: ThemeColors.dark().primary,
        selectionHandleColor: ThemeColors.dark().primary,
      ),
      sliderTheme: _getSliderTheme(isDark: true),
      switchTheme: _getSwitchTheme(isDark: true),
      textTheme: _getTextTheme(isDark: true),
      inputDecorationTheme: _getInputDecorationTheme(isDark: true),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ThemeColors.dark().text,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: ThemeColors.dark().brightness,
          systemNavigationBarColor: ThemeColors.dark().background,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: ThemeColors.dark().brightness,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: ThemeColors.dark().brightness,
        primary: ThemeColors.dark().primary,
        onPrimary: ThemeColors.dark().text,
        surface: ThemeColors.dark().surface,
        onSurface: ThemeColors.dark().text,
        error: ThemeColors.dark().error,
        onError: ThemeColors.dark().text,
      ),
      iconTheme: IconThemeData(
        color: ThemeColors.dark().text,
        size: 28,
      ),
    );
  }

  // Tema compartilhado para Slider
  static SliderThemeData _getSliderTheme({required bool isDark}) {
    return SliderThemeData(
      trackShape: const _CustomSliderTrackShape(),
      trackHeight: 3.0,
      inactiveTrackColor: isDark
          ? ThemeColors.dark().onBackground
          : ThemeColors.light().onBackground,
      inactiveTickMarkColor: isDark
          ? ThemeColors.dark().onBackground
          : ThemeColors.light().onBackground,
    );
  }

  // Tema compartilhado para Switch
  static SwitchThemeData _getSwitchTheme({required bool isDark}) {
    return SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => states.contains(WidgetState.selected)
            ? (isDark
                ? ThemeColors.dark().primary
                : ThemeColors.light().primary)
            : (isDark
                ? ThemeColors.dark().textGray
                : ThemeColors.light().textGray),
      ),
      thumbColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => states.contains(WidgetState.selected)
            ? (isDark ? ThemeColors.dark().text : ThemeColors.light().text)
            : (isDark
                ? ThemeColors.dark().background
                : ThemeColors.light().background),
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) => states.contains(WidgetState.selected)
            ? (isDark
                ? ThemeColors.dark().primary
                : ThemeColors.light().primary)
            : (isDark
                ? ThemeColors.dark().textGray
                : ThemeColors.light().textGray),
      ),
    );
  }

  // Tema compartilhado para Textos
  static TextTheme _getTextTheme({required bool isDark}) {
    return TextTheme(
      displayLarge: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      displayMedium: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 32,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      displaySmall: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 32,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      headlineLarge: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      headlineMedium: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      headlineSmall: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      titleLarge: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      titleMedium: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      titleSmall: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      bodyLarge: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      bodyMedium: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      bodySmall: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        fontFamily: 'OpenSans',
      ),
      labelLarge: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      labelMedium: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      labelSmall: TextStyle(
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
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
        color: isDark ? ThemeColors.dark().text : ThemeColors.light().text,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      floatingLabelStyle: TextStyle(
        color:
            isDark ? ThemeColors.dark().primary : ThemeColors.light().primary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      hintStyle: TextStyle(
        color:
            isDark ? ThemeColors.dark().textGray : ThemeColors.light().textGray,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'OpenSans',
      ),
      errorStyle: TextStyle(
        color: isDark ? ThemeColors.dark().error : ThemeColors.light().error,
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
