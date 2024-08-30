import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:playerhub/app/app_bindings.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/routes/app_pages.dart';
import 'package:playerhub/app/core/app_translater.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/app_shared.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme.fromSeed(
      seedColor: Colors.lightBlue,
    );

    return GetMaterialApp(
      title: AppShared.title,
      debugShowCheckedModeBanner: false,
      themeMode: AppColors.themeData,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      getPages: AppPages.pages,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.splash,
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      fallbackLocale: const Locale('pt', 'BR'),
      supportedLocales: const <Locale>[
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es', 'ES'),
      ],
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
