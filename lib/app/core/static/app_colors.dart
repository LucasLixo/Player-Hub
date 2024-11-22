import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:helper_hub/src/theme_colors.dart';
import 'package:get/instance_manager.dart';

abstract class AppColors {
  // ==================================================
  static ThemeColors current() {
    return ThemeColors.current(
      isDark: Get.find<AppShared>().getShared(SharedAttributes.darkMode),
    );
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
