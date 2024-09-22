import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/packages/just_audio_background.dart';
import 'package:playerhub/app/app_widget.dart';
import 'package:playerhub/app/routes/app_routes.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SemanticsBinding.instance.ensureSemantics();

    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(
        ['google_fonts'],
        await rootBundle.loadString('assets/fonts/OpenSans-OFL.txt'),
      );
    });
    await AppShared.loadTheme();

    runApp(Phoenix(child: const AppWidget()));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        JustAudioBackground.init(
          androidNotificationChannelId: "${AppShared.package}.channel.audio",
          androidNotificationChannelName: AppShared.title,
          androidShowNotificationBadge: true,
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
        AppShared.loadShared(),
      ]);

      Get.toNamed(AppRoutes.splash);
    });
  }, (Object error, StackTrace stack) {
    debugPrint("$error");
    debugPrintStack(stackTrace: stack);

    Get.toNamed(AppRoutes.error);
  });
}
