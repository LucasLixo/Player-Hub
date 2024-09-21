import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/app_bindings.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/routes/app_pages.dart';
import 'package:playerhub/app/core/app_translations.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/app_shared.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      title: AppShared.title,
      debugShowCheckedModeBanner: false,
      themeMode: AppColors.themeMode,
      theme: AppColors.themeData,
      darkTheme: AppColors.themeData,
      getPages: AppPages.pages,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.wait,
      translations: AppTranslations(),
      locale: Get.locale ?? Get.deviceLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const <Locale>[
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es', 'ES'),
      ],
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
