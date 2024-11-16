import 'package:shared_preferences/shared_preferences.dart';

enum SharedAttributes {
  // ==================================================
  /// bool
  darkMode(
    key: 'p6gsj4x3m4nnppf609s5hk8epf7pj4logdzs',
    value: true,
    type: bool,
  ),

  /// int
  defaultLanguage(
    key: '4lanbf0kwmq980kmk5rle2vuq4ojbmm2v2nl',
    value: 0,
    type: int,
  ),

  /// bool
  changeLanguage(
    key: 'q99lor2b2oe49jbqn2ekc85t3vk5a3y7rwrd',
    value: false,
    type: bool,
  ),

  /// int
  ignoreTime(
    key: 'ycuetteuw8cslcqhsjlket28d4xdxkqvfwir',
    value: 50,
    type: int,
  ),

  /// int
  getSongs(
    key: 'ay3ajkare4kmtkj28d06pvop7poald6h3c58',
    value: 0,
    type: int,
  ),

  /// int
  playlistMode(
    key: 'r6c9jgphg2mimgl0ipmzzyvrzdqfwc0ezytc',
    value: 1,
    type: int,
  ),

  /// bool
  equalizeMode(
    key: '42h96cwsfm34y379mrfbb7867zirvtc8yz7n',
    value: false,
    type: bool,
  ),

  /// List double
  frequency(
    key: 'kqxx5lnk8ls64jx4ve6g09n4ah0ttaaq9eua',
    value: [3.0, 0.0, 0.0, 0.0, 3.0],
    type: List<double>,
  ),

  /// List string
  ignoreFolder(
    key: '5enmh692h6p0loqqaj3izpgawe298wsoqbu2',
    value: <String>[],
    type: List<String>,
  );

  // ==================================================
  const SharedAttributes({
    required this.key,
    required this.value,
    required this.type,
  });

  // ==================================================
  final String key;
  final dynamic value;
  final Type type;

  // ==================================================
  static final List<String> getAttributesKey = [
    for (var index in SharedAttributes.values) index.key,
  ];

  // ==================================================
  static final List<String> getAttributesValue = [
    for (var index in SharedAttributes.values) index.value,
  ];

  // ==================================================
  static final List<String> getAttributesType = [
    for (var index in SharedAttributes.values) index.key,
  ];

  // ==================================================
  static final Map<String, dynamic> getAttributesMap = {
    for (var index in SharedAttributes.values) index.name: index.value,
  };

  // ==================================================
  static dynamic getValueShared(
    SharedPreferences sharedPreferences,
    SharedAttributes sharedIndexes,
  ) {
    dynamic result;
    switch (sharedIndexes.type) {
      case == String:
        result = sharedPreferences.getString(sharedIndexes.key);
        break;
      case == double:
        result = sharedPreferences.getDouble(sharedIndexes.key);
        break;
      case == int:
        result = sharedPreferences.getInt(sharedIndexes.key);
        break;
      case == bool:
        result = sharedPreferences.getBool(sharedIndexes.key);
        break;
      case == List<String>:
        result =
            sharedPreferences.getStringList(sharedIndexes.key) ?? <String>[];
        break;
      case == List<double>:
        result = List<double>.generate(
          sharedIndexes.value.length,
          (i) =>
              sharedPreferences.getDouble('${sharedIndexes.key}$i') ??
              sharedIndexes.value[i],
        );
        break;
    }
    return result ?? getAttributesMap[sharedIndexes.name];
  }

  // ==================================================
  static Future<void> setValueShared(
    SharedPreferences sharedPreferences,
    SharedAttributes sharedIndexes,
    dynamic value,
  ) async {
    switch (sharedIndexes.type) {
      case == String:
        await sharedPreferences.setString(sharedIndexes.key, value);
        break;
      case == double:
        await sharedPreferences.setDouble(sharedIndexes.key, value);
        break;
      case == int:
        await sharedPreferences.setInt(sharedIndexes.key, value);
        break;
      case == bool:
        await sharedPreferences.setBool(sharedIndexes.key, value);
        break;
      case == List<String>:
        await sharedPreferences.setStringList(sharedIndexes.key, value);
        break;
      case == List<double>:
        List<double> listValue = value as List<double>;
        for (int i = 0; i < listValue.length; i++) {
          await sharedPreferences.setDouble(
              '${sharedIndexes.key}$i', listValue[i]);
        }
        break;
    }
    getAttributesMap[sharedIndexes.name] = value;
  }
}
