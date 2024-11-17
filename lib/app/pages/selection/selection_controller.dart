import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SelectionController extends GetxController {
  final RxSet<int> selectedItems = <int>{}.obs;
  final RxList<SongModel> selectionList = <SongModel>[].obs;

  void toggleItemSelection(int index) {
    if (selectedItems.contains(index)) {
      selectedItems.remove(index);
    } else {
      selectedItems.add(index);
    }
  }

  List<SongModel> getSelectedSongs() {
    return selectedItems.map((index) => selectionList[index]).toList();
  }

  bool isSelected(int index) => selectedItems.contains(index);
}
