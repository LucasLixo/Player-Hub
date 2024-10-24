import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_shared.dart';

const toast = MethodChannel("${AppShared.package}/toast");

Future<void> showToast(String message) async {
  try {
    await toast.invokeMethod('showToast', {
      'message': message,
      'darkMode': AppShared.getShared(SharedAttributes.darkMode),
    });
  } on PlatformException catch (e) {
    debugPrint("Erro ao exibir toast: ${e.message}");
  }
}
