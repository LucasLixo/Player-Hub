enum ImageQuality {
  // ==================================================
  low(
    size: 32,
  ),
  high(
    size: 256,
  );

  // ==================================================
  const ImageQuality({
    required this.size,
  });

  // ==================================================
  final int size;
}
