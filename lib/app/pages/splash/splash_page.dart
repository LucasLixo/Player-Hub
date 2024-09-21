import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/core/app_shared.dart';

class SplashPage extends GetView<PlayerController> {
  SplashPage({super.key});

  final playerStateController = Get.find<PlayerStateController>();

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
      context: Get.context!,
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
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  'app_again'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeApp() async {
    if (playerStateController.songAllList.isEmpty) {
      AppShared.toggleIsLoading();
      await controller.getAllSongs();
      AppShared.toggleIsLoading();
    }

    Get.offNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    _permissionsApp();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: null,
      body: Center(
        child: Text(
          AppShared.title,
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => AppShared.isLoading.value
              ? ListTile(
                  tileColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  contentPadding: const EdgeInsets.all(0.0),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      playerStateController.songLog.value,
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  subtitle: LinearProgressIndicator(
                    minHeight: 4.0,
                    color: AppColors.primary,
                    backgroundColor: AppColors.background,
                  ),
                )
              : const SizedBox(
                  height: 4.0,
                ),
        ),
      ),
    );
  }
}
