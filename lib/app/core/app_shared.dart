import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:get/get.dart';
// import 'package:get/instance_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AppShared on GetxController {
  static SharedPreferences? _prefs;

  static const String _ignoreTimeKey = 'ignoreTime';
  static RxInt ignoreTimeValue = 50.obs;

  static const String _darkModeKey = 'darkMode';
  static RxBool darkModeValue = true.obs;

  static const String _equalizerMode = 'equalizerMode';
  static RxBool equalizerModeValue = false.obs;

  static const String _defaultGetSongsMode = 'defaultGetSongs';
  static RxInt defaultGetSongsValue = 0.obs;

  static const String _defaultLanguageValue = 'defaultLanguage';
  static RxInt defaultLanguageValue = 0.obs;

  static const String title = 'Player Hub';

  static const List<String> _imagePaths = [
    'assets/images/lowpoly_blue.jpg',
    'assets/images/lowpoly_green.jpg',
    'assets/images/lowpoly_red.jpg',
  ];

  static Future<void> _initializeDependencies() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> loadShared() async {
    await _initializeDependencies();
    ignoreTimeValue.value = getIgnoreTime();
    darkModeValue.value = getDarkMode();
    equalizerModeValue.value = getEqualizerMode();
    defaultGetSongsValue.value = getDefaultGetSong();
    defaultLanguageValue.value = getDefaultLanguage();
    switch (defaultLanguageValue.value) {
      case 0:
        Get.updateLocale(const Locale('en', 'US'));
        break;
      case 1:
        Get.updateLocale(const Locale('pt', 'BR'));
        break;
      case 2:
        Get.updateLocale(const Locale('es', 'ES'));
        break;
    }
  }

  static int getIgnoreTime() {
    return _prefs?.getInt(_ignoreTimeKey) ?? ignoreTimeValue.value;
  }

  static Future<void> setIgnoreTime(int value) async {
    await _prefs?.setInt(_ignoreTimeKey, value);
    ignoreTimeValue.value = value;
  }

  static bool getDarkMode() {
    return _prefs?.getBool(_darkModeKey) ?? darkModeValue.value;
  }

  static Future<void> setDarkMode(bool value) async {
    await _prefs?.setBool(_darkModeKey, value);
    darkModeValue.value = value;
  }

  static bool getEqualizerMode() {
    return _prefs?.getBool(_equalizerMode) ?? equalizerModeValue.value;
  }

  static Future<void> setEqualizerMode(bool value) async {
    await _prefs?.setBool(_equalizerMode, value);
    equalizerModeValue.value = value;
  }

  static int getDefaultGetSong() {
    return _prefs?.getInt(_defaultGetSongsMode) ?? defaultGetSongsValue.value;
  }

  static Future<void> setDefaultGetSong(int value) async {
    await _prefs?.setInt(_defaultGetSongsMode, value);
    defaultGetSongsValue.value = value;
  }

  static int getDefaultLanguage() {
    return _prefs?.getInt(_defaultLanguageValue) ?? defaultLanguageValue.value;
  }

  static Future<void> setDefaultLanguage(int value) async {
    await _prefs?.setInt(_defaultLanguageValue, value);
    defaultLanguageValue.value = value;
    switch (value) {
      case 0:
        Get.updateLocale(const Locale('en', 'US'));
        break;
      case 1:
        Get.updateLocale(const Locale('pt', 'BR'));
        break;
      case 2:
        Get.updateLocale(const Locale('es', 'ES'));
        break;
    }
  }

  static String getTitle(int id, String value) {
    String? title2 = _prefs?.getString('title-${id.toString()}');
    if (title2 != null) {
      return title2;
    }
    return value;
  }

  static Future<void> setTitle(int id, String value) async {
    await _prefs?.setString('title-${id.toString()}', value);
  }

  static String getArtist(int id, String value) {
    String? artist2 = _prefs?.getString('artist-${id.toString()}');
    if (artist2 != null) {
      return artist2;
    }
    return value == '<unknown>' ? '' : value;
  }

  static Future<void> setArtist(int id, String value) async {
    await _prefs?.setString('artist-${id.toString()}', value);
  }

  static Future<String> getImage({required int id}) async {
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
      final String randomImagePath =
          _imagePaths[Random().nextInt(_imagePaths.length)];
      final ByteData imageData = await rootBundle.load(randomImagePath);
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      await file.writeAsBytes(imageBytes);
    }

    return file.path;
  }
}
