import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../shared/utils/dynamic_style.dart';
import '../routes/app_routes.dart';
import '../core/app_permissions.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    appPermissions();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));

    Get.offNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackgroundDark,
      appBar: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            constAppTitle,
            style: dynamicStyle(
              32,
              colorWhite,
              FontWeight.normal,
              FontStyle.normal,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          const LinearProgressIndicator(
            color: colorSlider,
            backgroundColor: colorBackground,
          ),
        ],
      ),
    );
  }
}
