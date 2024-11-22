import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/services/app_chrome.dart';
import 'package:player_hub/app/services/app_network.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/app_widget.dart';
import 'package:player_hub/app/routes/app_routes.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SemanticsBinding.instance.ensureSemantics();

    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(
        ['google_fonts'],
        await rootBundle.loadString('assets/licenses/OpenSans-OFL.txt'),
      );
    });

    Get.put<AppShared>(AppShared());
    await Get.find<AppShared>().init();

    runApp(Phoenix(child: const AppWidget()));

    Get.put<AppNetwork>(AppNetwork());
    Get.put<AppChrome>(AppChrome());

    await Future.wait([
      JustAudioBackground.init(
        androidNotificationChannelId: "${AppManifest.package}.channel.audio",
        androidNotificationChannelName: AppManifest.title,
        androidShowNotificationBadge: true,
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
      Get.find<AppNetwork>().init(),
      Get.find<AppChrome>().init(),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.toNamed(AppRoutes.splash, arguments: {
        'function': () async {
          await Get.find<AppShared>().updatedLocale();
        },
      });
    });
  }, (Object error, StackTrace stack) async {
    debugPrint("$error");
    debugPrintStack(stackTrace: stack);

    await Get.offAllNamed(AppRoutes.error);
  });
}
