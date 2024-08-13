import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app_widget.dart';
import 'app/core/app_colors.dart';
import 'app/core/just_audio_background/just_audio_background.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light,
    //     systemNavigationBarColor: colorBackgroundDark,
    //     systemNavigationBarIconBrightness: Brightness.light,
    //   ),
    // );

    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidShowNotificationBadge: true,
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    );

    runApp(const AppWidget());
  }, (Object error, StackTrace stack) {
    print('==============================');
    print(error);
    print('==============================');
  });
}
