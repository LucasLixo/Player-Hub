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
  final Uint8List? data = await audioQuery.queryArtwork(
    id,
    ArtworkType.AUDIO,
    format: ArtworkFormat.JPEG,
    size: 192,
    quality: 100,
  );

  final tempDir = await getTemporaryDirectory();

  final File file = File('${tempDir.path}/${id.toString()}.jpg');

  if (data != null) {
    if (!await file.exists()) {
      await file.writeAsBytes(data);
    }
  } else {
    if (!await file.exists()) {
      String fileRandom = imagePaths[Random().nextInt(imagePaths.length)];
      final ByteData fileLoad = await rootBundle.load(fileRandom);
      final Uint8List bytes = fileLoad.buffer.asUint8List();

      await file.writeAsBytes(bytes);
    }
  }

  return file.path;
}
