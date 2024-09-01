import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
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
      // builder: _builder,
      builder: (context, child) {
        return ToastificationConfigProvider(
          config: const ToastificationConfig(
            alignment: Alignment.bottomCenter,
            itemWidth: 440,
            animationDuration: Duration(milliseconds: 400),
          ),
          child: child!,
        );
      },
    );
  }

  // Widget _builder(context, widget) {
  //   Widget error = const Text('...');
  // 
  //   if (widget is Scaffold || widget is Navigator) {
  //     error = Scaffold(body: Center(child: error));
  //   }
  // 
  //   ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
  // 
  //   return widget;
  // }
}
