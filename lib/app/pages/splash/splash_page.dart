import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/core/app_shared.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final playerStateController = Get.find<PlayerStateController>();

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _permissionsApp();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _permissionsApp() async {
    PermissionStatus audioPermissionStatus;

    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

    if (build.version.sdkInt >= 33) {
      audioPermissionStatus = await Permission.audio.request();
    } else {
      audioPermissionStatus = await Permission.storage.request();
    }

    if (audioPermissionStatus.isGranted) {
      await _initializeApp();
    } else if (audioPermissionStatus.isDenied) {
      await _showDialogError();
    } else if (audioPermissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<String?> _showDialogError() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'app_permision1'.tr,
                style: titleStyle(),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  'app_again'.tr,
                  style: dynamicStyle(
                    fontSize: 16,
                    fontColor: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeApp() async {
    Get.offNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: null,
      body: Center(
        child: /* Text(
          AppShared.title,
          style: dynamicStyle(
            32,
            AppColors.text,
            FontWeight.normal,
            FontStyle.normal,
          ),
          textAlign: TextAlign.center,
        ), */
            Lottie.asset(
          AppShared.darkModeValue.value
              ? 'assets/lottie/splash_black.json'
              : 'assets/lottie/splash_white.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = Duration(seconds: 1)
              ..forward();
          },
        ),
      ),
    );
  }
}
