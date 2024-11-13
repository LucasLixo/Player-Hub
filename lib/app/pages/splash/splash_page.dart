import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_shared.dart';

class SplashPage extends GetView<PlayerController> {
  final bool waitSecond;
  final RxBool isRequestingPermission = false.obs;

  SplashPage({
    super.key,
    required this.waitSecond,
  });

  Future<void> _permissionsApp() async {
    if (isRequestingPermission.value) return;
    isRequestingPermission.value = true;

    PermissionStatus audioPermissionStatus;
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

    try {
      if (build.version.sdkInt >= 33) {
        audioPermissionStatus = await Permission.audio.request();
      } else {
        audioPermissionStatus = await Permission.storage.request();
      }

      if (audioPermissionStatus.isGranted) {
        await _initializeApp();
      } else if (audioPermissionStatus.isDenied) {
        await showWindowConfirm(
          context: Get.context!,
          colors: AppColors.current(),
          title: 'app_again'.tr,
          subtitle: 'app_permision1'.tr,
          textConfirm: 'crud_sheet_dialog_1'.tr,
          textCancel: 'crud_sheet_dialog_2'.tr,
          confirm: () => SystemNavigator.pop(),
          cancel: null,
        );
      } else if (audioPermissionStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
    } finally {
      isRequestingPermission.value = false;
    }
  }

  Future<void> _initializeApp() async {
    if (controller.songAllList.isEmpty) {
      await controller.getAllSongs();
    }

    if (waitSecond) {
      await Future.delayed(const Duration(seconds: 1));
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
            AppShared.title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        bottomNavigationBar: ListTile(
          tileColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          title: Obx(() {
            if (controller.songLog.value.isNotEmpty) {
              return Text(
                controller.songLog.value,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          subtitle: Obx(() {
            if (waitSecond.obs.value || controller.songLog.value.isNotEmpty) {
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
