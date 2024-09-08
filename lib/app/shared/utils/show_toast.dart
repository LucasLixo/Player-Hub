import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playerhub/app/core/app_shared.dart';

const toast = MethodChannel("${AppShared.package}/toast");

Future<void> showToast(String message) async {
  try {
    await toast.invokeMethod('showToast', {'message': message, 'darkMode': AppShared.darkModeValue.value});
  } on PlatformException catch (e) {
    debugPrint("Erro ao exibir toast: ${e.message}");
  }
}
