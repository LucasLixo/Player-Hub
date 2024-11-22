import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/shared/dialog/dialog_text.dart';

class SplashPage extends StatelessWidget {
  final PlayerController playerController = Get.find<PlayerController>();

  final Future<void> Function()? function;
  final RxBool isRequestingPermission = false.obs;

  SplashPage({
    super.key,
    required this.function,
  });

  Future<void> _permissionsApp() async {
    if (isRequestingPermission.value) return;
    isRequestingPermission.value = true;

    PermissionStatus audioPermissionStatus;
    final AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

    try {
      if (build.version.sdkInt >= 33) {
        audioPermissionStatus = await Permission.audio.request();
      } else {
        audioPermissionStatus = await Permission.storage.request();
      }

      if (audioPermissionStatus.isGranted) {
        await _initializeApp();
      } else if (audioPermissionStatus.isDenied) {
        await dialogText(
          title: 'app_again'.tr,
          description: 'app_permision1'.tr,
        );
        await SystemNavigator.pop();
      } else if (audioPermissionStatus.isPermanentlyDenied) {
        await openAppSettings();
        await SystemNavigator.pop();
      }
    } finally {
      isRequestingPermission.value = false;
    }
  }

  Future<void> _initializeApp() async {
    if (playerController.songAllList.isEmpty) {
      await playerController.getAllSongs();
    }

    if (function != null) {
      await function!();
    }

    await Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _permissionsApp();
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.current().background,
        appBar: null,
        body: Center(
          child: Text(
            AppManifest.title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        bottomNavigationBar: ListTile(
          tileColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          title: Obx(() {
            return Text(
              playerController.songLog.value.isNotEmpty
                  ? playerController.songLog.value
                  : '',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
          subtitle: Obx(() {
            if (function.obs.value != null ||
                playerController.songLog.value.isNotEmpty) {
              return LinearProgressIndicator(
                color: AppColors.current().primary,
                backgroundColor: AppColors.current().surface,
                minHeight: 4.0,
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ),
      ),
    );
  }
}
