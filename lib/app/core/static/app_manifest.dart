import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/array_image_types.dart';
import 'package:player_hub/app/core/static/app_shared.dart';

abstract class AppManifest {
  // ==================================================
  static const List<String> _imageColors = [
    'blue',
    'green',
    'red',
  ];

  // ==================================================
  static Future<Uint8List> getImageArray({
    required int id,
    ArrayImageTypes type = ArrayImageTypes.low,
  }) async {
    late File file;

    switch (type) {
      case ArrayImageTypes.low:
        file = File('${AppShared.documentDir.path}/${id}_64.jpg');
        break;
      case ArrayImageTypes.high:
        file = File('${AppShared.documentDir.path}/${id}_256.jpg');
        break;
    }

    return file.readAsBytes();
  }

  // ==================================================
  static Future<String> getImageFile({
    required int id,
    required ArrayImageTypes type,
  }) async {
    final File fileLow = File('${AppShared.documentDir.path}/${id}_64.jpg');
    final File fileHigh = File('${AppShared.documentDir.path}/${id}_256.jpg');

    if (!await fileLow.exists() || !await fileHigh.exists()) {
      await _generateImageFile(id: id);
    }

    switch (type) {
      case ArrayImageTypes.low:
        return fileLow.path;
      case ArrayImageTypes.high:
        return fileHigh.path;
    }
  }

  // ==================================================
  static Future<void> _generateImageFile({
    required int id,
  }) async {
    final OnAudioQuery audioQuery = OnAudioQuery();

    final File fileLow = File('${AppShared.documentDir.path}/${id}_64.jpg');
    final File fileHigh = File('${AppShared.documentDir.path}/${id}_256.jpg');

    final List<Uint8List?> dataResults = await Future.wait([
      audioQuery.queryArtwork(
        id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: 64,
        quality: 100,
      ),
      audioQuery.queryArtwork(
        id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: 256,
        quality: 100,
      ),
    ]);
    final Uint8List? dataLow = dataResults[0];
    final Uint8List? dataHigh = dataResults[1];

    if (dataLow != null &&
        dataLow.isNotEmpty &&
        dataHigh != null &&
        dataHigh.isNotEmpty) {
      await fileLow.writeAsBytes(dataLow);
      await fileHigh.writeAsBytes(dataHigh);
    } else {
      final String randomImageColor =
          _imageColors[Random().nextInt(_imageColors.length)];

      final ByteData imageDataLow =
          await rootBundle.load('assets/images/low_poly_$randomImageColor.jpg');
      final Uint8List imageBytesLow = imageDataLow.buffer.asUint8List();

      final ByteData imageDataHigh = await rootBundle
          .load('assets/images/high_poly_$randomImageColor.jpg');
      final Uint8List imageBytesHigh = imageDataHigh.buffer.asUint8List();

      await fileLow.writeAsBytes(imageBytesLow);
      await fileHigh.writeAsBytes(imageBytesHigh);
    }
  }

  // ==================================================
  static Future<void> setImageFile({
    required int id,
    required Uint8List bytes,
  }) async {
    final File fileLow = File('${AppShared.documentDir.path}/${id}_64.jpg');
    final File fileHigh = File('${AppShared.documentDir.path}/${id}_256.jpg');

    await fileLow.writeAsBytes(bytes);
    await fileHigh.writeAsBytes(bytes);
  }

  // ==================================================
  static String encodeToBase64(String input) {
    List<int> bytes = utf8.encode(input);
    String encoded = base64.encode(bytes);
    return encoded;
  }

  // ==================================================
  static String decodeFromBase64(String encoded) {
    List<int> decodedBytes = base64.decode(encoded);
    String decoded = utf8.decode(decodedBytes);
    return decoded;
  }
}
