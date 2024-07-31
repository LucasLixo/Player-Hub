import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:player/components/style_text.dart';
import 'package:player/screens/home.dart';
import 'package:player/screens/search.dart';
import 'package:player/utils/request_storage.dart';
import 'package:player/utils/const.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  WidgetsFlutterBinding.ensureInitialized();

  bool permissionStorage = await requestStorage();

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
      home: Scaffold(
        backgroundColor: colorBackgroundDark,
        appBar: AppBar(
          backgroundColor: colorBackgroundDark,
          actions: [
            InkWell(
              onTap: () {
                Get.to(
                  () => const Search(),
                  transition: Transition.rightToLeft,
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(
                Icons.search,
                color: colorWhite,
                size: 32,
              ),
            ),
          ],
          title: Text('Player Hub', style: styleText(fontSize: 24)),
        ),
        body: permissionStorage
            ? const Home()
            : Center(
                child: Text('Permissão Negada',
                    style: styleText(fontFamily: bold)),
              ),
      ),
    );
  }
}
