import 'package:flutter/material.dart';

TextStyle dynamicStyle({
  required double fontSize,
  required Color color,
  required FontWeight fontWeight,
  required FontStyle fontStyle,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: 'OpenSans',
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  );
}
