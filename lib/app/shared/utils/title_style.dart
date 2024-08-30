import 'dart:ui';
import 'package:flutter/src/painting/text_style.dart';
import 'package:playerhub/app/core/app_colors.dart';

TextStyle titleStyle() {
  return TextStyle(
    fontSize: 16,
    fontFamily: 'OpenSans',
    color: AppColors.text,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );
}
