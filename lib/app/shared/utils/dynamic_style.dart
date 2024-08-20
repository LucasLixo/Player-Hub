import 'package:flutter/material.dart';

dynamicStyle(
  double fontSize,
  Color color,
  FontWeight fontWeight,
  FontStyle fontStyle,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: 'OpenSans',
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  );
}
