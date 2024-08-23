import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

const List<String> imagePaths = [
  'assets/images/lowpoly_blue.jpg',
  'assets/images/lowpoly_green.jpg',
  'assets/images/lowpoly_red.jpg',
];

Future<String> getImage({required int id}) async {
  final audioQuery = OnAudioQuery();
  final tempDir = await getTemporaryDirectory();
  final File file = File('${tempDir.path}/$id.jpg');

  if (await file.exists()) {
    return file.path;
  }

  final Uint8List? data = await audioQuery.queryArtwork(
    id,
    ArtworkType.AUDIO,
    format: ArtworkFormat.JPEG,
    size: 192,
    quality: 100,
  );

  if (data != null && data.isNotEmpty) {
    await file.writeAsBytes(data);
  } else {
    final String randomImagePath = imagePaths[Random().nextInt(imagePaths.length)];
    final ByteData imageData = await rootBundle.load(randomImagePath);
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    await file.writeAsBytes(imageBytes);
  }

  return file.path;
}
