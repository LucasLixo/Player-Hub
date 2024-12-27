import 'dart:io';
import 'dart:math';
import 'dart:convert' as convert;

import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/image_quality.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:get/instance_manager.dart';

abstract class AppManifest {
  // ==================================================
  static final AppShared _sharedController = Get.find<AppShared>();

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
            '${_sharedController.documentDir.path}/${id}_${ImageQuality.low.name}.jpg');
        break;
      case ImageQuality.high:
        file = File(
            '${_sharedController.documentDir.path}/${id}_${ImageQuality.high.name}.jpg');
        break;
    }

    return await file.readAsBytes();
  }

  // ==================================================
  static Future<String> getImageFile({
    required int id,
    required ImageQuality type,
  }) async {
    final File targetFile =
        File('${_sharedController.documentDir.path}/${id}_${type.name}.jpg');

    if (!await targetFile.exists()) {
      _generateImageFile(id: id);
    }

    return targetFile.path;
  }

  // ==================================================
  static Future<void> setImageFile({
    required int id,
    required Uint8List bytes,
  }) async {
    final File fileLow = File(
        '${_sharedController.documentDir.path}/${id}_${ImageQuality.low.name}.jpg');
    final File fileHigh = File(
        '${_sharedController.documentDir.path}/${id}_${ImageQuality.high.name}.jpg');

    await fileLow.writeAsBytes(bytes);
    await fileHigh.writeAsBytes(bytes);
  }

  // ==================================================
  static Future<void> _generateImageFile({
    required int id,
  }) async {
    final OnAudioQuery audioQuery = OnAudioQuery();

    final List<String> filePaths = [
      '${_sharedController.documentDir.path}/${id}_${ImageQuality.low.name}.jpg',
      '${_sharedController.documentDir.path}/${id}_${ImageQuality.high.name}.jpg',
    ];

    final List<Uint8List?> dataResults = await Future.wait([
      audioQuery.queryArtwork(
        id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: ImageQuality.low.size,
        quality: 100,
      ),
      audioQuery.queryArtwork(
        id,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: ImageQuality.high.size,
        quality: 100,
      ),
    ]);

    if (dataResults[0]?.isNotEmpty == true &&
        dataResults[1]?.isNotEmpty == true) {
      await Future.wait([
        File(filePaths[0]).writeAsBytes(dataResults[0]!),
        File(filePaths[1]).writeAsBytes(dataResults[1]!),
      ]);
    } else {
      final String randomImageColor =
          _imageColors[Random().nextInt(_imageColors.length)];

      final List<Uint8List> defaultImages = await Future.wait([
        _loadAssetImage('assets/images/low_poly_$randomImageColor.jpg'),
        _loadAssetImage('assets/images/high_poly_$randomImageColor.jpg'),
      ]);

      await Future.wait([
        File(filePaths[0]).writeAsBytes(defaultImages[0]),
        File(filePaths[1]).writeAsBytes(defaultImages[1]),
      ]);
    }
  }

  static Future<Uint8List> _loadAssetImage(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  // ==================================================
  static String encodeToBase64(String input) {
    List<int> bytes = convert.utf8.encode(input);
    String encoded = convert.base64.encode(bytes);
    return encoded;
  }

  // ==================================================
  static String decodeFromBase64(String encoded) {
    List<int> decodedBytes = convert.base64.decode(encoded);
    String decoded = convert.utf8.decode(decodedBytes);
    return decoded;
  }
}
