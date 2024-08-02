import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedStateController extends GetxController {
  final _prefs = SharedPreferences.getInstance();

  Future<void> saveValue(String key, dynamic value) async {
    final prefs = await _prefs;

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported type');
    }
  }

  Future<dynamic> loadValue(String key) async {
    final prefs = await _prefs;
    return prefs.get(key);
  }

  Future<bool> deleteValue(String key) async {
    final prefs = await _prefs;
    return await prefs.remove(key);
  }

  Future<bool> updateValue(String key, dynamic value) async {
    final prefs = await _prefs;
    if (prefs.containsKey(key)) {
      await saveValue(key, value);
      return true;
    }
    return false;
  }

  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return await prefs.clear();
  }
}
