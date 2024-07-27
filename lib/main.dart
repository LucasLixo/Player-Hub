import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/components/style_text.dart';
import 'package:player/screens/home.dart';
import 'package:player/utils/request_storage.dart';
import 'package:player/utils/request_notifications.dart';
import 'package:player/utils/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool permissionStorage = await requestStorage();
  bool permissionNotifications = await requestNotifications();

  runApp(MyApp(permissionStorage: permissionStorage, permissionNotifications: permissionNotifications,));
}

class MyApp extends StatelessWidget {
  final bool permissionStorage;
  final bool permissionNotifications;

  const MyApp({super.key, required this.permissionStorage, required this.permissionNotifications});

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
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: colorWhite,
                size: 32,
              ),
            ),
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: colorWhite,
            size: 32,
          ),
          title: Text('Player Hub', style: styleText(fontFamily: bold)),
        ),
        body: permissionStorage && permissionNotifications
            ? const Home()
            : Center(
                child: Text('Permissão Negada',
                    style: styleText(fontFamily: bold)),
              ),
      ),
    );
  }
}
