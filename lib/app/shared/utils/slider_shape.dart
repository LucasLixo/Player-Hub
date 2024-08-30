import 'dart:ui';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter/src/material/slider_theme.dart';

SliderThemeData getSliderTheme() {
  
  return const SliderThemeData(
    trackShape: _CustomSliderTrackShape(),
    trackHeight: 3.0,
  );
}

class _CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const _CustomSliderTrackShape();
  
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
