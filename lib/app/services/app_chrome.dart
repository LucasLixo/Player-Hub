import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:player_hub/app/core/enums/theme_types.dart';
import 'package:player_hub/app/core/static/app_colors.dart';

class AppChrome extends GetxService {
  // ==================================================
  Future<void> init() async {
    await Future.wait([
      _setPreferredOrientations(),
      _setSystemUIMode(),
    ]);
    loadTheme();
  }

  // ==================================================
  Future<void> _setPreferredOrientations() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // ==================================================
  Future<void> _setSystemUIMode() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
  }

  // ==================================================
  void loadTheme({bool isRebirth = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        loadThemeByType(ThemeTypes.topOneBottomOne),
      );
    });

    if (isRebirth && Get.context != null) {
      Phoenix.rebirth(Get.context!);
    }
  }

  // ==================================================
  SystemUiOverlayStyle loadThemeByType(ThemeTypes theme) {
    switch (theme) {
      case ThemeTypes.defaultDark:
        return const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        );
      case ThemeTypes.defaultLight:
        return const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        );
      case ThemeTypes.topOneBottomOne:
        return SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: AppColors.current().brightness,
          systemNavigationBarColor: AppColors.current().background,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: AppColors.current().brightness,
        );
      case ThemeTypes.topOneBottomTwo:
        return SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: AppColors.current().brightness,
          systemNavigationBarColor: AppColors.current().surface,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: AppColors.current().brightness,
        );
      case ThemeTypes.topTwoBottomOne:
        return SystemUiOverlayStyle(
          statusBarColor: AppColors.current().surface,
          statusBarIconBrightness: AppColors.current().brightness,
          systemNavigationBarColor: AppColors.current().background,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: AppColors.current().brightness,
        );
      case ThemeTypes.topTwoBottomTwo:
        return SystemUiOverlayStyle(
          statusBarColor: AppColors.current().surface,
          statusBarIconBrightness: AppColors.current().brightness,
          systemNavigationBarColor: AppColors.current().surface,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: AppColors.current().brightness,
        );
    }
  }
}
