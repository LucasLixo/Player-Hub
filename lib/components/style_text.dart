import 'package:flutter/material.dart';
import 'package:player/utils/const.dart';

const String bold = 'bold';
const String regular = 'regular';
const String italic = 'italic';

styleText({
  String fontFamily = regular,
  double? fontSize = 18,
  Color color = colorWhite,
}) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    color: color,
  );
}
