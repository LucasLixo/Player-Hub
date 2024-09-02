import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:playerhub/app/app_wait.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/just_audio_background.dart';
import 'package:playerhub/app/app_widget.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(
        ['google_fonts'],
        await rootBundle.loadString('assets/fonts/OpenSans-OFL.txt'),
      );
    });

    await AppShared.loadTheme();

    runApp(const AppWait());

    await Future.wait([
      JustAudioBackground.init(
        androidNotificationChannelId: 'com.lucasalves.playerhub.channel.audio',
        androidNotificationChannelName: AppShared.title,
        androidShowNotificationBadge: true,
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
      AppShared.loadShared(),
    ]);

    runApp(Phoenix(child: const AppWidget()));
  }, (Object error, StackTrace stack) {
    // print('\n\n==============================');
    // print(error);
    // print('==============================\n\n');
    runApp(const AppWait());
  });
}
