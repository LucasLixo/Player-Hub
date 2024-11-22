import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:player_hub/app/core/static/app_colors.dart';

class AppChrome extends GetxService {
  Future<void> init() async {
    await Future.wait([
      _setPreferredOrientations(),
      _setSystemUIMode(),
    ]);
    loadTheme();
  }

  Future<void> _setPreferredOrientations() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> _setSystemUIMode() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );
  }

  void loadTheme({bool isRebirth = false}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: AppColors.current().brightness,
        systemNavigationBarColor: AppColors.current().background,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: AppColors.current().brightness,
      ),
    );

    if (isRebirth && Get.context != null) {
      Phoenix.rebirth(Get.context!);
    }
  }
}
