import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_routes.dart';
import 'core/app_constants.dart';
import 'core/app_permissions.dart';
import 'routes/app_pages.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: app_permissions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == false) {
          return const Scaffold(body: Center(child: Text('Sem Permissão')));
        } else {
          return GetMaterialApp(
            title: constAppTitle,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(),
            themeMode: ThemeMode.dark,
            getPages: AppPages.pages,
            initialRoute: AppRoutes.home,
            builder: _builder,
          );
        }
      },
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