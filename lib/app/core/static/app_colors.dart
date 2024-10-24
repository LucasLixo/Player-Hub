import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:helper_hub/src/theme_colors.dart';

abstract class AppColors {
  // ==================================================
  static ThemeColors current() {
    return ThemeColors.current(
        isDark: AppShared.getShared(SharedAttributes.darkMode));
  }

  // ==================================================
  static ThemeColors light() {
    return ThemeColors.light();
  }

  // ==================================================
  static ThemeColors dark() {
    return ThemeColors.dark();
  }
}
