import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_bindings.dart';
import 'routes/app_routes.dart';
import 'core/app_constants.dart';
import 'routes/app_pages.dart';
import 'core/app_translater.dart';
import 'core/app_colors.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme.fromSeed(
      seedColor: Colors.blue,
    );

    return GetMaterialApp(
      title: constAppTitle,
      debugShowCheckedModeBanner: false,
      themeMode: AppColors.themeData,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      getPages: AppPages.pages,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.splash,
      builder: _builder,
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es', 'ES'),
      ],
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
