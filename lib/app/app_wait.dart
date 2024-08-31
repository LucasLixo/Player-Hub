import 'package:flutter/material.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_shared.dart';

class AppWait extends StatelessWidget {
  const AppWait({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.background,
        appBar: null,
        body: Center(
          child: Text(
            AppShared.title,
            style: dynamicStyle(
              32,
              AppColors.text,
              FontWeight.normal,
              FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
