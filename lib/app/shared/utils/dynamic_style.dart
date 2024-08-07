import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

dynamicStyle(
  double fontSize,
  Color color,
  FontWeight fontWeight,
  FontStyle fontStyle,
) {
  return GoogleFonts.openSans(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  );
}
