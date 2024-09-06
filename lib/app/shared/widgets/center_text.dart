import 'package:flutter/material.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';

class CenterText extends StatelessWidget {
  final String title;

  const CenterText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: dynamicStyle(
          fontSize: 18,
          fontColor: AppColors.text,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
