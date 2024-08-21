import 'dart:async';
import 'package:flutter/material.dart';
import 'package:player/app/core/app_shared.dart';

import './app/core/controllers/just_audio_background.dart';
import './app/app_widget.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.cornflower.player.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidShowNotificationBadge: true,
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    );

    AppShared.loadShared();

    runApp(const AppWidget());
  
  }, (Object error, StackTrace stack) {
    print('==============================');
    print(error);
    print('==============================');
  });
}
