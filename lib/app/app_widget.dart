import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_routes.dart';
import 'core/app_constants.dart';
import 'routes/app_pages.dart';
import 'core/app_colors.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme.fromSeed(
      seedColor: colorPrimary,
      primary: colorPrimary,
    );

    return GetMaterialApp(
      title: constAppTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      themeMode: ThemeMode.dark,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
      builder: _builder,
    );
  }

  Widget _builder(context, widget) {
    Widget error = const Text('...');

    if (widget is Scaffold || widget is Navigator) {
      error = Scaffold(body: Center(child: error));
    }

    ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;

    return widget;
  }
}
