import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:get/instance_manager.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mixin to manage preferences and images in the application using GetX.
mixin AppShared on GetxController {
  static SharedPreferences? _prefs;

  // Preference Keys
  static const String _ignoreTimeValue = 'ignoreTime';
  static const String _darkModeValue = 'darkMode';
  // static const String _equalizerModeValue = 'equalizerMode';
  static const String _defaultGetSongsValue = 'defaultGetSongs';
  static const String _defaultLanguageValue = 'defaultLanguage';
  static const String _languageChangedValue = 'languageChanged';
  static const String _playlistModeValue = 'playlistMode';
  static const String _frequencyValue = 'frequency';

  // Observable Values
  static RxInt ignoreTimeValue = 50.obs;
  static RxBool darkModeValue = true.obs;
  static RxBool equalizerModeValue = false.obs;
  static RxInt defaultGetSongsValue = 0.obs;
  static RxInt defaultLanguageValue = 0.obs;
  static RxBool languageChangedValue = false.obs;
  static RxInt playlistModeValue = 1.obs;
  static RxList<double> frequencyValue = [
    3.0,
    0.0,
    0.0,
    0.0,
    3.0,
  ].obs;
  static RxBool isLoading = false.obs;

  // Random background image title and paths
  static const String title = 'Player Hub';
  static const String package = 'com.lucasalves.playerhub';
  static const List<String> _imagePaths = [
    'assets/images/lowpoly_blue.jpg',
    'assets/images/lowpoly_green.jpg',
    'assets/images/lowpoly_red.jpg',
  ];

  // Initialize dependencies
  static Future<void> _initializeDependencies() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Loads the current theme
  static Future<void> loadTheme() async {
    await _initializeDependencies();
    darkModeValue.value = getDarkMode();
    loadNavigationBar();
  }

  static void loadNavigationBar() {
    // Get.changeTheme(darkModeValue.value ? lightTheme : darkTheme);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: AppColors.brightnessData,
    ));
  }

  static void toggleIsLoading() {
    isLoading.value = !isLoading.value;
  }

  // Load shared preferences
  static Future<void> loadShared() async {
    await _initializeDependencies();
    ignoreTimeValue.value = getIgnoreTime();
    equalizerModeValue.value = getEqualizerMode();
    defaultGetSongsValue.value = getDefaultGetSong();
    defaultLanguageValue.value = getDefaultLanguage();
    languageChangedValue.value = getLanguageChanged();
    playlistModeValue.value = getPlaylistMode();
    frequencyValue.value = getAllFrequency();

    if (languageChangedValue.value) {
      _updateLocale(defaultLanguageValue.value);
    }
  }

  // Function to update the language
  static void _updateLocale(int value) {
    Map<int, Locale> localeMap = {
      0: const Locale('en', 'US'),
      1: const Locale('pt', 'BR'),
      2: const Locale('es', 'ES'),
    };
    Get.updateLocale(localeMap[value] ?? const Locale('en', 'US'));
  }

  // Get the ignored time value from preferences
  static int getIgnoreTime() =>
      _prefs?.getInt(_ignoreTimeValue) ?? ignoreTimeValue.value;

  // Set skipped time in preferences
  static Future<void> setIgnoreTime(int value) async {
    ignoreTimeValue.value = value;
    await _prefs?.setInt(_ignoreTimeValue, value);
  }

  // Gets the dark mode value from preferences
  static bool getDarkMode() =>
      _prefs?.getBool(_darkModeValue) ?? darkModeValue.value;

  // Sets the dark mode in preferences
  static Future<void> setDarkMode(bool value) async {
    darkModeValue.value = value;
    await _prefs?.setBool(_darkModeValue, value);
    loadNavigationBar();
  }

  // Gets the equalizer value from preferences
  static bool getEqualizerMode() => equalizerModeValue.value;
  // _prefs?.getBool(_equalizerModeValue) ??

  // Sets the equalizer in preferences
  static Future<void> setEqualizerMode(bool value) async {
    equalizerModeValue.value = value;
    // await _prefs?.setBool(_equalizerModeValue, value);
  }

  // Gets the default value for music from preferences
  static int getDefaultGetSong() =>
      _prefs?.getInt(_defaultGetSongsValue) ?? defaultGetSongsValue.value;

  // Sets the default value for getting songs in preferences
  static Future<void> setDefaultGetSong(int value) async {
    defaultGetSongsValue.value = value;
    await _prefs?.setInt(_defaultGetSongsValue, value);
  }

  // Gets the default language from preferences
  static int getDefaultLanguage() =>
      _prefs?.getInt(_defaultLanguageValue) ?? defaultLanguageValue.value;

  // Sets the default language in preferences and updates the locale
  static Future<void> setDefaultLanguage(int value) async {
    defaultLanguageValue.value = value;
    await _prefs?.setInt(_defaultLanguageValue, value);
    _updateLocale(value);
    if (!languageChangedValue.value) {
      setLanguageChanged(true);
    }
  }

  // Gets the language switching state from preferences
  static bool getLanguageChanged() =>
      _prefs?.getBool(_languageChangedValue) ?? languageChangedValue.value;

  // Sets the language switching state in preferences
  static Future<void> setLanguageChanged(bool value) async {
    languageChangedValue.value = value;
    await _prefs?.setBool(_languageChangedValue, value);
  }

  // Gets the language switching state from preferences
  static int getPlaylistMode() =>
      _prefs?.getInt(_playlistModeValue) ?? playlistModeValue.value;

  // Sets the language switching state in preferences
  static Future<void> setPlaylistMode(int value) async {
    playlistModeValue.value = value;
    await _prefs?.setInt(_playlistModeValue, value);
  }

  static List<double> getAllFrequency() {
    List<double> frequencies = [];
    for (int i = 0; i < 5; i++) {
      double frequency =
          _prefs?.getDouble("$_frequencyValue$i") ?? frequencyValue[i];
      frequencies.add(frequency);
    }
    return frequencies;
  }

  static Future<void> setAllFrequency(List<double> values) async {
    for (int i = 0; i < 5; i++) {
      await _prefs?.setDouble("$_frequencyValue$i", values[i]);
    }
  }

  // ==================================================
  // Gets the song title based on ID
  static String getTitle(int id, String value) =>
      _prefs?.getString('title-$id') ?? value;

  // Sets the song title in preferences
  static Future<void> setTitle(int id, String value) async {
    await _prefs?.setString('title-$id', value);
  }

  // ==================================================
  // Gets the song's artist based on the ID
  static String getArtist(int id, String value) {
    String? artist = _prefs?.getString('artist-$id');
    return artist ?? (value == '<unknown>' ? '' : value);
  }

  // Sets the song's artist in preferences
  static Future<void> setArtist(int id, String value) async {
    await _prefs?.setString('artist-$id', value);
  }

  // ==================================================
  // Gets the song's image based on the ID, or a random image if not available
  // ==================================================
  static Future<Uint8List> getImageArray({required int id}) async {
    final audioQuery = OnAudioQuery();

    // Tries to get the album art
    final Uint8List? data = await audioQuery.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 64,
      quality: 100,
    );

    if (data != null && data.isNotEmpty) {
      return data;
    } else {
      final String randomImagePath =
          _imagePaths[Random().nextInt(_imagePaths.length)];
      final ByteData imageData = await rootBundle.load(randomImagePath);
      return imageData.buffer.asUint8List();
    }
  }

  static Future<String> getImageFile({required int id}) async {
    final audioQuery = OnAudioQuery();
    final tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/$id.jpg');

    // Returns the path if the image already exists
    if (await file.exists()) return file.path;

    // Tries to get the album art
    final Uint8List? data = await audioQuery.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 256,
      quality: 100,
    );

    // If the artwork is found, save it to the temporary directory
    if (data != null && data.isNotEmpty) {
      await file.writeAsBytes(data);
    } else {
      // If not, save a random image from the assets
      final String randomImagePath =
          _imagePaths[Random().nextInt(_imagePaths.length)];
      final ByteData imageData = await rootBundle.load(randomImagePath);
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      await file.writeAsBytes(imageBytes);
    }

    return file.path;
  }
}
