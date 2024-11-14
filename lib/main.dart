import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/app_widget.dart';
import 'package:player_hub/app/routes/app_routes.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SemanticsBinding.instance.ensureSemantics();

    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(
        ['google_fonts'],
        await rootBundle.loadString('assets/licenses/OpenSans-OFL.txt'),
      );
    });

    runApp(Phoenix(child: const AppWidget()));

    Future.wait([
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]),
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ],
      ),
      JustAudioBackground.init(
        androidNotificationChannelId: "${AppShared.package}.channel.audio",
        androidNotificationChannelName: AppShared.title,
        androidShowNotificationBadge: true,
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
      AppShared.loadSettings(),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.toNamed(AppRoutes.splash);
    });
  }, (Object error, StackTrace stack) async {
    debugPrint("$error");
    debugPrintStack(stackTrace: stack);

    await Get.toNamed(AppRoutes.error);
  });
}
