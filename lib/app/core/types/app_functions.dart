import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_shared.dart';

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
    final MethodChannel toast =
        const MethodChannel("${AppShared.package}/toast");

    try {
      await toast.invokeMethod('showToast', {
        'message': message,
        'darkMode': AppShared.getShared(SharedAttributes.darkMode),
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
}
