import 'package:get/state_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/static/app_colors.dart';

class AppNetwork extends GetxService {
  // ==================================================
  final RxBool isFirst = false.obs;

  final RxBool isConnectivity = false.obs;

  // ==================================================
  final Connectivity _connectivity = Connectivity();

  Future<void> init() async {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

// ==================================================
  Future<void> _updateConnectionStatus(
    ConnectivityResult connectivityResult,
  ) async {
    Get.rawSnackbar(
      messageText: Text(
        'app_network'.tr,
        style: Theme.of(Get.context!).textTheme.bodyMedium,
      ),
      isDismissible: false,
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.current().error,
      icon: Icon(
        Icons.wifi_off,
        color: AppColors.current().text,
        size: 35,
      ),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 8.0,
      ),
      snackStyle: SnackStyle.GROUNDED,
    );
    if (connectivityResult == ConnectivityResult.none) {
      if (Get.isSnackbarOpen) {
        await Get.closeCurrentSnackbar();
      }
      isConnectivity.value = false;
      Get.rawSnackbar(
        messageText: Text(
          'app_network'.tr,
          style: Theme.of(Get.context!).textTheme.bodyMedium,
        ),
        isDismissible: false,
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.current().error,
        icon: Icon(
          Icons.wifi_off,
          color: AppColors.current().text,
          size: 35,
        ),
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 8.0,
        ),
        snackStyle: SnackStyle.GROUNDED,
      );
      if (!isFirst.value) {
        isFirst.value = true;
      }
    } else {
      if (Get.isSnackbarOpen) {
        await Get.closeCurrentSnackbar();
      }
      isConnectivity.value = true;
      if (isFirst.value) {
        Get.rawSnackbar(
          messageText: Text(
            'app_wifi'.tr,
            style: Theme.of(Get.context!).textTheme.bodyMedium,
          ),
          isDismissible: false,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.current().success,
          icon: Icon(
            Icons.wifi,
            color: AppColors.current().text,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 8.0,
          ),
          snackStyle: SnackStyle.GROUNDED,
        );
      }
    }
  }
}
