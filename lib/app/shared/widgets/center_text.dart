import 'package:flutter/material.dart';

import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';

class CenterText extends StatelessWidget {
  final String title;

  const CenterText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: dynamicStyle(
          18,
          AppColors.text,
          FontWeight.normal,
          FontStyle.normal,
        ),
      ),
    );
  }
}
