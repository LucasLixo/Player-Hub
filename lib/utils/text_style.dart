import 'package:flutter/material.dart';
import 'package:player/utils/colors.dart';

const String bold = 'bold';
const String regular = 'regular';
const String italic = 'italic';

TextStyle textStyle({
  String fontFamily = regular,
  double fontSize = 18,
  Color color = colorWhite,
}) {
  FontWeight fontWeight;
  FontStyle fontStyle = FontStyle.normal;

  switch (fontFamily) {
    case bold:
      fontWeight = FontWeight.bold;
      break;
    case italic:
      fontStyle = FontStyle.italic;
      fontWeight = FontWeight.normal;
      break;
    case regular:
    default:
      fontWeight = FontWeight.normal;
  }

  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  );
}
