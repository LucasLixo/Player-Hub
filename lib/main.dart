import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/components/style_text.dart';
import 'package:player/screens/home.dart';
import 'package:player/utils/request_permission.dart';
import 'package:player/utils/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool permission = await requestPermission();

  runApp(MyApp(permission: permission));
}

class MyApp extends StatelessWidget {
  final bool permission;

  const MyApp({super.key, required this.permission});

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
        body: permission
            ? const Home()
            : Center(
                child: Text('Permissão Negada',
                    style: styleText(fontFamily: bold)),
              ),
      ),
    );
  }
}
