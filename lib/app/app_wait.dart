import 'package:flutter/material.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_shared.dart';

class AppWait extends StatelessWidget {
  final bool error;

  const AppWait({super.key, required this.error});

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
              fontSize: 32,
              fontColor: error ? Colors.red : AppColors.text,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
