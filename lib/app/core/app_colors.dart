import 'package:playerhub/app/core/app_shared.dart';
import 'package:helper_hub/src/theme_colors.dart';

abstract class AppColors {
  // Theme current
  static ThemeColors current() {
    return ThemeColors.current(isDark: AppShared.darkModeValue.value);
  }

  // Theme light
  static ThemeColors light() {
    return ThemeColors.light();
  }

  // Theme dark
  static ThemeColors dark() {
    return ThemeColors.dark();
  }
}
