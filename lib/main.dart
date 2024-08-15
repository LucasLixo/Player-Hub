import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_widget.dart';
import 'app/core/app_colors.dart';
import 'app/core/controllers/just_audio_background.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidShowNotificationBadge: true,
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppColors.isDarkMode.value = prefs.getBool('isDarkMode') ?? true;

    runApp(const AppWidget());
  
  }, (Object error, StackTrace stack) {
    print('==============================');
    print(error);
    print('==============================');
  });
}
