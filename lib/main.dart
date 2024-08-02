import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/controllers/just_audio_background.dart';
import 'package:player/screens/home.dart';
import 'package:player/utils/request_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool permissionStorage = await requestStorage();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Music playback',
    androidShowNotificationBadge: true,
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
  );

  runApp(MyApp(
    permissionStorage: permissionStorage,
  ));
}

class MyApp extends StatelessWidget {
  final bool permissionStorage;

  const MyApp({
    super.key,
    required this.permissionStorage,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Player Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          useMaterial3: true,
        ),
        home: permissionStorage ? const Home() : null);
  }
}
