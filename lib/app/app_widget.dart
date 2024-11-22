import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:helper_hub/src/theme_material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/routes/app_bindings.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/routes/app_pages.dart';
import 'package:player_hub/app/core/types/app_translations.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/services/app_chrome.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _onEnterApp();
    } else if (state == AppLifecycleState.paused) {
      _onExitApp();
    }
  }

  void _onEnterApp() {
    Get.find<AppChrome>().loadTheme(isRebirth: false);
  }

  void _onExitApp() {}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      enableLog: true,
      title: AppManifest.title,
      debugShowCheckedModeBanner: false,
      themeMode: AppColors.current().themeMode,
      theme: ThemeMaterial.light(),
      darkTheme: ThemeMaterial.dark(),
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
