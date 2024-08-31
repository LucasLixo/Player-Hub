import 'dart:async';
import 'package:flutter/src/widgets/binding.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:playerhub/app/app_wait.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/just_audio_background.dart';
import 'package:playerhub/app/app_widget.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(const AppWait());

    await Future.wait([
      JustAudioBackground.init(
        androidNotificationChannelId: 'com.cornflower.playerhub.channel.audio',
        androidNotificationChannelName: AppShared.title,
        androidShowNotificationBadge: true,
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
      AppShared.loadShared(),
      Future.delayed(const Duration(seconds: 1)),
    ]);

    runApp(Phoenix(child: const AppWidget()));
  }, (Object error, StackTrace stack) {
    print('\n\n==============================');
    print(error);
    print('==============================\n\n');
  });
}
