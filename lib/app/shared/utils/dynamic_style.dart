import 'package:flutter/material.dart';

TextStyle dynamicStyle({
  required double fontSize,
  required Color fontColor,
  required FontWeight fontWeight,
  required FontStyle fontStyle,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: 'OpenSans',
    color: fontColor,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  );
}
