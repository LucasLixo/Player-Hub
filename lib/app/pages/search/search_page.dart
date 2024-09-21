import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/widgets/music_list.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/widgets/shortcut.dart';

class SearchPage extends GetView<PlayerStateController> {
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Get.back(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text,
            size: 26,
          ),
        ),
        title: TextField(
          controller: _textController,
          focusNode: _focusNode,
          style: Theme.of(context).textTheme.titleMedium,
          cursorColor: AppColors.text,
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.text),
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
              ? const SizedBox.shrink()
              : MusicList(
                  songs: controller.filteredSongs,
                ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => controller.songAllList.isEmpty
            ? const SizedBox.shrink()
            : const SafeArea(
                child: Shortcut(),
              ),
      ),
    );
  }
}
