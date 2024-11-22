import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/image_quality.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:get/instance_manager.dart';

abstract class AppManifest {
  // ==================================================
  static final AppShared sharedController = Get.find<AppShared>();

  // ==================================================
  static const String title = 'Player Hub';
  static const String package = 'hub.player.listen';

  // ==================================================
  static const List<String> _imageColors = [
    'blue',
    'green',
    'red',
  ];

  // ==================================================
  static Future<Uint8List> getImageArray({
    required int id,
    ImageQuality type = ImageQuality.high,
  }) async {
    late File file;

    switch (type) {
      case ImageQuality.low:
        file = File(
            '${sharedController.documentDir.path}/${id}_${ImageQuality.low.size}.jpg');
        break;
      case ImageQuality.high:
        file = File(
            '${sharedController.documentDir.path}/${id}_${ImageQuality.high.size}.jpg');
        break;
    }

    return file.readAsBytes();
  }

  // ==================================================
  static Future<String> getImageFile({
    required int id,
    required ImageQuality type,
  }) async {
    final File fileLow = File(
        '${sharedController.documentDir.path}/${id}_${ImageQuality.low.size}.jpg');
    final File fileHigh = File(
        '${sharedController.documentDir.path}/${id}_${ImageQuality.high.size}.jpg');

    if (!await fileLow.exists() || !await fileHigh.exists()) {
      await _generateImageFile(id: id);
    }

    switch (type) {
      case ImageQuality.low:
        return fileLow.path;
      case ImageQuality.high:
        return fileHigh.path;
    }
  }

  // ==================================================
  static Future<void> setImageFile({
    required int id,
    required Uint8List bytes,
  }) async {
    final File fileLow =
        File('${sharedController.documentDir.path}/${id}_64.jpg');
    final File fileHigh =
        File('${sharedController.documentDir.path}/${id}_256.jpg');

    await fileLow.writeAsBytes(bytes);
    await fileHigh.writeAsBytes(bytes);
  }

  // ==================================================
  static Future<void> _generateImageFile({
    required int id,
  }) async {
    final OnAudioQuery audioQuery = OnAudioQuery();

    final File fileLow = File(
        '${sharedController.documentDir.path}/${id}_${ImageQuality.low.size}.jpg');
    final File fileHigh = File(
        '${sharedController.documentDir.path}/${id}_${ImageQuality.high.size}.jpg');

    final List<Uint8List?> dataResults = await Future.wait([
      audioQuery.queryArtwork(
        id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: ImageQuality.low.size,
        quality: 90,
      ),
      audioQuery.queryArtwork(
        id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: ImageQuality.high.size,
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
