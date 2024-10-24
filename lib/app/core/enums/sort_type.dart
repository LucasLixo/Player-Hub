import 'package:get/get_utils/src/extensions/internacionalization.dart';

enum SortType {
  // ==================================================
  byAtoZ(
    code: 0,
  ),
  byMostAdded(
    code: 1,
  ),
  byLongestDuration(
    code: 2,
  );

  // ==================================================
  const SortType({
    required this.code,
  });

  // ==================================================
  final int code;

  // ==================================================
  static final List<int> getTypeCode = [
    for (var index in SortType.values) index.code,
  ];

  // ==================================================
  static String getTypeTitlebyCode(int index) {
    switch (index) {
      case 0:
        return 'setting_sort2'.tr;
      case 1:
        return 'setting_sort1'.tr;
      case 2:
        return 'setting_sort3'.tr;
      default:
        throw ArgumentError('Index must be between 0 and 2');
    }
  }
}
