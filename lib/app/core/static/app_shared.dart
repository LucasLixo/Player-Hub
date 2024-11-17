import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:player_hub/app/core/enums/languages.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class to manage preferences and images in the application using GetX.
abstract class AppShared extends GetxController {
  // ==================================================
  static late SharedPreferences _prefs;
  static late Directory _temporaryDir;
  static late Directory _documentDir;

  // ==================================================
  static final RxMap<String, dynamic> sharedMap =
      Map<String, dynamic>.from(SharedAttributes.getAttributesMap).obs;

  // ==================================================
  static const String title = 'Player Hub';
  static const String package = 'hub.player.listen';

  // ==================================================
  static Directory get temporaryDir => _temporaryDir;
  static set temporaryDir(Directory value) => _temporaryDir = value;
  static Directory get documentDir => _documentDir;
  static set documentDir(Directory value) => _documentDir = value;

  // ==================================================
  // Initialize dependencies
  static Future<void> _initializeDependencies() async {
    _prefs = await SharedPreferences.getInstance();
    temporaryDir = await getApplicationCacheDirectory();
    documentDir = await getApplicationDocumentsDirectory();
  }

  // ==================================================
  static Future<void> loadSettings() async {
    await _initializeDependencies();

    final List<SharedAttributes> listSettings = [
      SharedAttributes.darkMode,
      SharedAttributes.defaultLanguage,
      SharedAttributes.changeLanguage,
      SharedAttributes.ignoreTime,
      // SharedAttributes.equalizeMode,
      SharedAttributes.playlistMode,
      SharedAttributes.frequency,
      SharedAttributes.ignoreFolder,
      SharedAttributes.listAllPlaylist,
    ];

    for (var setting in listSettings) {
      SharedAttributes.getAttributesMap[setting.name] =
          SharedAttributes.getValueShared(
        _prefs,
        setting,
      );
      sharedMap[setting.name] = SharedAttributes.getAttributesMap[setting.name];
    }

    await loadTheme();
  }

  // ==================================================
  static Future<void> loadTheme([
    bool isRebirth = true,
  ]) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: AppColors.current().brightness,
        systemNavigationBarColor: AppColors.current().background,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: AppColors.current().brightness,
      ),
    );

    if (isRebirth) {
      await Phoenix.rebirth(Get.context!);
    }
  }

  static Future<void> updatedLocale() async {
    int code = await AppShared.getShared(SharedAttributes.defaultLanguage);

    await Get.updateLocale(Locale(
      AppLanguages.getLanguagesLocale[code][0],
      AppLanguages.getLanguagesLocale[code][1],
    ));
  }

  // ==================================================
  static dynamic getShared(SharedAttributes appShared) {
    return sharedMap[appShared.name];
  }

  // ==================================================
  static Future<void> setShared(
    SharedAttributes appShared,
    dynamic value,
  ) async {
    await SharedAttributes.setValueShared(_prefs, appShared, value);
    sharedMap[appShared.name] = value;
  }

  // ==================================================
  static String getGenerateHash([int length = 32]) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    return List.generate(
        length, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  // ==================================================
  // Gets the song title based on ID
  static String getTitle(int id, String value) {
    return _prefs.getString('title-$id') ?? value;
  }

  // ==================================================
  // Sets the song title in preferences
  static Future<void> setTitle(int id, String value) async {
    await _prefs.setString('title-$id', value);
  }

  // ==================================================
  // Gets the song's artist based on the ID
  static String getArtist(int id, String value) {
    String? artist = _prefs.getString('artist-$id');
    return artist ?? (value == '<unknown>' ? '' : value);
  }

  // ==================================================
  // Sets the song's artist in preferences
  static Future<void> setArtist(int id, String value) async {
    await _prefs.setString('artist-$id', value);
  }

  // ==================================================
  // Gets the playlist based on ID
  static List<int> getPlaylist(String name) {
    return _prefs
            .getStringList('playlist-${AppManifest.encodeToBase64(name)}')
            ?.map((e) => int.parse(e))
            .toList() ??
        <int>[];
  }

  // ==================================================
  // Sets the playlist in preferences
  static Future<void> setPlaylist(String name, List<int> value) async {
    await _prefs.setStringList(
      'playlist-${AppManifest.encodeToBase64(name)}',
      value.map((e) => e.toString()).toList(),
    );
  }

  // ==================================================
  // Delete the playlist in preferences
  static Future<void> deletePlaylist(String name) async {
    await _prefs.remove('playlist-${AppManifest.encodeToBase64(name)}');
  }
}
