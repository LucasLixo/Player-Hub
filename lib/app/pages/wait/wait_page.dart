import 'package:flutter/material.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/core/types/app_functions.dart';

class WaitPage extends StatelessWidget with AppFunctions {
  final bool error;

  const WaitPage({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.current().background,
        appBar: null,
        body: Center(
          child: Text(
            AppManifest.title,
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
