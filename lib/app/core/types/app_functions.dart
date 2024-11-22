import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:get/instance_manager.dart';

mixin AppFunctions {
  // ==================================================
  TextStyle dynamicStyle({
    required double fontSize,
    required Color color,
    required FontWeight fontWeight,
    required FontStyle fontStyle,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: 'OpenSans',
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }

  // ==================================================
  Future<void> showToast(String message) async {
    final AppShared sharedController = Get.find<AppShared>();

    final MethodChannel toast =
        const MethodChannel("${AppManifest.package}/toast");

    try {
      await toast.invokeMethod('showToast', {
        'message': message,
        'darkMode': sharedController.getShared(SharedAttributes.darkMode),
      });
    } on PlatformException catch (e) {
      debugPrint("Erro ao exibir toast: ${e.message}");
    }
  }

  // ==================================================
  void printDebug(dynamic debug) {
    print('================================\n');
    print(debug);
    print('\n================================');
  }

  // ==================================================
  String getGenerateHash([int length = 32]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    return List.generate(
        length, (index) => chars[Random().nextInt(chars.length)]).join();
  }
}
