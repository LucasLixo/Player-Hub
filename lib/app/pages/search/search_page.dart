import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/shared/widgets/music_list.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/shared/widgets/shortcut.dart';
import 'package:helper_hub/src/theme_widget.dart';

class SearchPage extends GetView<PlayerController> {
  SearchPage({super.key});

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    void filterSongs() {
      var query = _textController.text.toLowerCase();

      if (query.isEmpty) {
        controller.filteredSongs.clear();
      } else {
        controller.filteredSongs.value = controller.songAllList.where((song) {
          return song.title.toLowerCase().contains(query) ||
              AppShared.getArtist(song.id, song.artist!)
                  .toLowerCase()
                  .contains(query);
        }).toList();
      }
    }

    _textController.addListener(filterSongs);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.current().background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.current().background,
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: TextField(
            controller: _textController,
            focusNode: _focusNode,
            style: Theme.of(context).textTheme.titleMedium,
            cursorColor: AppColors.current().text,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.current().text),
              ),
              labelText: 'app_search'.tr,
              labelStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Obx(
            () => controller.filteredSongs.isEmpty
                ? const Space(size: 0)
                : MusicList(
                    songs: controller.filteredSongs,
                  ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => controller.songAllList.isEmpty
              ? const Space(size: 0)
              : const Shortcut(),
        ),
      ),
    );
  }
}
