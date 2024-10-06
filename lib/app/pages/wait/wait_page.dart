import 'package:flutter/material.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';

class WaitPage extends StatelessWidget {
  final bool error;

  const WaitPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.current().background,
        appBar: null,
        body: Center(
          child: Text(
            AppShared.title,
            style: dynamicStyle(
              fontSize: 32,
              color:
                  error ? AppColors.current().error : AppColors.current().text,
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
