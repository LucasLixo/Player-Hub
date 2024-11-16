import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:image/image.dart' as img;
import 'package:player_hub/app/core/static/app_shared.dart';

abstract class AppManifest {
  // ==================================================
  static Future<Uint8List> getImageArray({required int id}) async {
    final File imageFile = File(await getImageFile(id: id));

    final Uint8List imageBytes = await imageFile.readAsBytes();

    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      image = img.copyResize(
        image,
        width: 64,
        height: 64,
      );

      return Uint8List.fromList(img.encodeJpg(image));
    }

    return imageBytes;
  }

  // ==================================================
  static Future<String> getImageFile({required int id}) async {
    final File file = File('${AppShared.documentDir.path}/$id.jpg');

    if (await file.exists()) return file.path;

    final List<String> imagePaths = [
      'assets/images/lowpoly_blue.jpg',
      'assets/images/lowpoly_green.jpg',
      'assets/images/lowpoly_red.jpg',
    ];
    final audioQuery = OnAudioQuery();

    final Uint8List? data = await audioQuery.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 256,
      quality: 100,
    );

    if (data != null && data.isNotEmpty) {
      await file.writeAsBytes(data);
    } else {
      final String randomImagePath =
          imagePaths[Random().nextInt(imagePaths.length)];
      final ByteData imageData = await rootBundle.load(randomImagePath);
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      await file.writeAsBytes(imageBytes);
    }

    return file.path;
  }

  // ==================================================
  static Future<void> setImageFile({
    required int id,
    required Uint8List bytes,
  }) async {
    try {
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        return;
      }
      image = img.copyResize(
        image,
        width: 256,
        height: 256,
      );

      final File file = File('${AppShared.documentDir.path}/$id.jpg');
      await file.writeAsBytes(img.encodeJpg(image, quality: 100));
    } catch (e) {
      return;
    }
  }
}
