import 'package:get_storage/get_storage.dart';

enum SharedAttributes {
  // ==================================================
  /// bool
  darkMode(
    key: 'p6gsj4x3m4nnppf609s5hk8epf7pj4logdzs',
    value: true,
  ),

  /// int
  defaultLanguage(
    key: '4lanbf0kwmq980kmk5rle2vuq4ojbmm2v2nl',
    value: 0,
  ),

  /// bool
  changeLanguage(
    key: 'q99lor2b2oe49jbqn2ekc85t3vk5a3y7rwrd',
    value: false,
  ),

  /// int
  ignoreTime(
    key: 'ycuetteuw8cslcqhsjlket28d4xdxkqvfwir',
    value: 50,
  ),

  /// int
  getSongs(
    key: 'ay3ajkare4kmtkj28d06pvop7poald6h3c58',
    value: 0,
  ),

  /// int
  playlistMode(
    key: 'r6c9jgphg2mimgl0ipmzzyvrzdqfwc0ezytc',
    value: 1,
  ),

  /// bool
  equalizeMode(
    key: '42h96cwsfm34y379mrfbb7867zirvtc8yz7n',
    value: false,
  ),

  /// List double
  frequency(
    key: 'kqxx5lnk8ls64jx4ve6g09n4ah0ttaaq9eua',
    value: [0.0, 0.0, 0.0, 0.0, 0.0],
  ),

  /// List string
  listAllPlaylist(
    key: '9ebnkopoibwnbwn97yrjjtj679225krm3rp7',
    value: <String>[],
  ),

  /// List string
  ignoreFolder(
    key: '5enmh692h6p0loqqaj3izpgawe298wsoqbu2',
    value: <String>[],
  );

  // ==================================================
  const SharedAttributes({
    required this.key,
    required this.value,
  });

  // ==================================================
  final String key;
  final dynamic value;

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
    GetStorage sotrage,
    SharedAttributes sharedIndexes,
  ) {
    final dynamic result = sotrage.read(sharedIndexes.key);

    if (result != null) {
      switch (sharedIndexes) {
        case frequency:
          return result.cast<double>();
        case listAllPlaylist:
        case ignoreFolder:
          return result.cast<String>();
        default:
          break;
      }
    }

    return result ?? getAttributesMap[sharedIndexes.name];
  }

  // ==================================================
  static Future<void> setValueShared(
    GetStorage storage,
    SharedAttributes sharedIndexes,
    dynamic value,
  ) async {
    await storage.write(sharedIndexes.key, value);

    getAttributesMap[sharedIndexes.name] = value;
  }
}
