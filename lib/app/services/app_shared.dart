import 'dart:io';

import 'package:flutter/material.dart';
import 'package:player_hub/app/core/enums/box_types.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player_hub/app/core/enums/languages.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:get_storage/get_storage.dart';

class AppShared extends GetxController {
  // ==================================================
  late GetStorage _boxApp;
  late GetStorage _boxStorage;
  late GetStorage boxOthers;

  // ==================================================
  late Directory temporaryDir;
  late Directory documentDir;

  // ==================================================
  final RxMap<String, dynamic> sharedMap =
      Map<String, dynamic>.from(SharedAttributes.getAttributesMap).obs;

  // ==================================================
  Future<void> init() async {
    await Future.wait([
      GetStorage.init(BoxTypes.app.toString()),
      GetStorage.init(BoxTypes.storage.toString()),
      GetStorage.init(BoxTypes.others.toString()),
    ]);

    _boxApp = GetStorage(BoxTypes.app.toString());
    _boxStorage = GetStorage(BoxTypes.storage.toString());
    boxOthers = GetStorage(BoxTypes.others.toString());

    temporaryDir = await getApplicationCacheDirectory();
    documentDir = await getApplicationDocumentsDirectory();

    final List<SharedAttributes> listSettings = SharedAttributes.values;
    final List<SharedAttributes> removeSettings = [
      SharedAttributes.equalizeMode,
    ];

    for (var setting in listSettings) {
      if (removeSettings.contains(setting)) {
        continue;
      }
      final dynamic value = SharedAttributes.getValueShared(_boxApp, setting);
      SharedAttributes.getAttributesMap[setting.name] = value;
      sharedMap[setting.name] = value;
    }
  }

  // ==================================================
  Future<void> updatedLocale() async {
    final int code = getShared<int>(SharedAttributes.defaultLanguage);

    await Get.updateLocale(Locale(
      AppLanguages.getLanguagesLocale[code][0],
      AppLanguages.getLanguagesLocale[code][1],
    ));
  }

  // ==================================================
  T getShared<T>(SharedAttributes appShared) {
    return sharedMap[appShared.name];
  }

  // ==================================================
  Future<void> setShared(
    SharedAttributes appShared,
    dynamic value,
  ) async {
    await SharedAttributes.setValueShared(
      _boxApp,
      appShared,
      value,
    );
    sharedMap[appShared.name] = value;
  }

  // ==================================================
  // Gets the song title based on ID
  String getTitle(int id, String value) {
    return _boxStorage.read<String>('title-$id') ?? value;
  }

  // ==================================================
  // Sets the song title in preferences
  Future<void> setTitle(int id, String value) async {
    await _boxStorage.write('title-$id', value);
  }

  // ==================================================
  // Gets the song's artist based on the ID
  String getArtist(int id, String value) {
    String? artist = _boxStorage.read<String>('artist-$id');
    return artist ?? (value == '<unknown>' ? '' : value);
  }

  // ==================================================
  // Sets the song's artist in preferences
  Future<void> setArtist(int id, String value) async {
    await _boxStorage.write('artist-$id', value);
  }

  // ==================================================
  // Gets the playlist based on ID
  List<int> getPlaylist(String name) {
    final List<dynamic>? playlist = _boxStorage
        .read<List<dynamic>>('playlist-${AppManifest.encodeToBase64(name)}');
    if (playlist == null) {
      return <int>[];
    }
    return playlist.cast<int>();
  }

  // ==================================================
  // Sets the playlist in preferences
  Future<void> setPlaylist(String name, List<int> value) async {
    await _boxStorage.write(
      'playlist-${AppManifest.encodeToBase64(name)}',
      value,
    );
  }

  // ==================================================
  // Delete the playlist in preferences
  Future<void> deletePlaylist(String name) async {
    await _boxStorage.remove('playlist-${AppManifest.encodeToBase64(name)}');
  }
}
