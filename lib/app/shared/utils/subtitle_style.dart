import 'dart:ui';
import 'package:flutter/src/painting/text_style.dart';
import 'package:playerhub/app/core/app_colors.dart';

TextStyle subtitleStyle() {
  return TextStyle(
    fontSize: 14,
    fontFamily: 'OpenSans',
    color: AppColors.text,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  );
}

