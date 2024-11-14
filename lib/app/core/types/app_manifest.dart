import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/static/app_shared.dart';

mixin AppManifest {
  // ==================================================
  void printDebug(dynamic debug) {
    print('================================\n');
    print(debug);
    print('\n================================');
  }

  // ==================================================
  final List<String> imagePaths = [
    'assets/images/lowpoly_blue.jpg',
    'assets/images/lowpoly_green.jpg',
    'assets/images/lowpoly_red.jpg',
  ];

  // ==================================================
  Future<Uint8List> getImageArray({required int id}) async {
    // final audioQuery = OnAudioQuery();

    // final Uint8List? data = await audioQuery.queryArtwork(
    //   id,
    //   ArtworkType.AUDIO,
    //   format: ArtworkFormat.JPEG,
    //   size: 64,
    //   quality: 100,
    // );

    // if (data != null && data.isNotEmpty) {
    //   return data;
    // } else {
    // }
    final File imageFile = File(await getImageFile(id: id));
    return imageFile.readAsBytes();
  }

  // ==================================================
  Future<String> getImageFile({required int id}) async {
    final audioQuery = OnAudioQuery();

    final File file = File('${AppShared.documentDir.path}/$id.jpg');

    if (await file.exists()) return file.path;

    final Uint8List? data = await audioQuery.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 128, // 256,
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
  Future<void> setImageFile({required int id, required Uint8List bytes}) async {
    final File file = File('${AppShared.documentDir.path}/$id.jpg');
    await file.writeAsBytes(bytes);
  }
}
