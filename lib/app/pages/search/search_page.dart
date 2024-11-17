import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/shared/class/shortcut.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:player_hub/app/shared/widgets/music_list.dart';

class SearchPage extends GetView<PlayerController> {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.unfocus();
    });

    void filterSongs() {
      var query = textController.text.toLowerCase();

      if (query.isEmpty) {
        controller.filteredSongs.clear();
      } else {
        controller.filteredSongs.value = controller.songAppList.where((song) {
          return song.title.toLowerCase().contains(query) ||
              AppShared.getArtist(song.id, song.artist!)
                  .toLowerCase()
                  .contains(query);
        }).toList();
      }
    }

    textController.addListener(filterSongs);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        focusNode.unfocus();
        Get.back();
        textController.clear();
        textController.dispose();
        focusNode.dispose();
      },
      child: Scaffold(
        backgroundColor: AppColors.current().background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.current().surface,
          leading: InkWell(
            onTap: () {
              focusNode.unfocus();
              Get.back();
              textController.clear();
              textController.dispose();
              focusNode.dispose();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.current().text,
              size: 32,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextField(
              cursorHeight: 28.0,
              controller: textController,
              focusNode: focusNode,
              style: Theme.of(context).textTheme.titleMedium,
              cursorColor: AppColors.current().text,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.current().text),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.current().text),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.current().text),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: 'app_search'.tr,
                labelStyle: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Obx(
              () => controller.filteredSongs.isEmpty
                  ? const Space(size: 0)
                  : GestureDetector(
                      onTap: () {
                        focusNode.unfocus();
                      },
                      child: musicList(
                        songs: controller.filteredSongs,
                      ),
                    ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => controller.songAppList.isEmpty
              ? const Space(size: 0)
              : GestureDetector(
                  onTap: () {
                    focusNode.unfocus();
                  },
                  child: const Shortcut(),
                ),
        ),
      ),
    );
  }
}
