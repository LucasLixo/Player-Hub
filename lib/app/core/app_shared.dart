import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin AppShared on GetxController {
  static SharedPreferences? _prefs;

  static const String _ignoreTimeKey = 'ignoreTime';
  static RxInt ignoreTimeValue = 50.obs;

  static const String _darkModeKey = 'darkMode';
  static RxBool darkModeValue = true.obs;

  static const String _equalizerMode = 'equalizerMode';
  static RxBool equalizerModeValue = false.obs;

  static const String title = 'Player Hub';

  static Future<void> _initializeDependencies() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> loadShared() async {
    await _initializeDependencies();
    ignoreTimeValue.value = getIgnoreTime();
    darkModeValue.value = getDarkMode();
    equalizerModeValue.value = getEqualizerMode();
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
}
