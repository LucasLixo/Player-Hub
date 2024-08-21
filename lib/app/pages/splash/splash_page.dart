import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/utils/title_style.dart';
import '../../core/app_colors.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../routes/app_routes.dart';
import '../../core/controllers/player.dart';
import '../../core/app_shared.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final playerStateController = Get.find<PlayerStateController>();

  @override
  void initState() {
    super.initState();

    _permissionsApp();
  }

  @override
  void dispose() {
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
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  'app_again'.tr,
                  style: dynamicStyle(
                    16,
                    AppColors.primary,
                    FontWeight.w600,
                    FontStyle.normal,
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
    await Future.delayed(const Duration(seconds: 1));

    Get.offNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: null,
      body: Center(
        child: Text(
          AppShared.title,
          style: dynamicStyle(
            32,
            AppColors.text,
            FontWeight.normal,
            FontStyle.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
