import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/core/enums/theme_types.dart';
import 'package:player_hub/app/services/app_chrome.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/shared/class/shortcut.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:player_hub/app/shared/widgets/music_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Get.find<PlayerController>();
    final AppShared sharedController = Get.find<AppShared>();
    final AppChrome chromeController = Get.find<AppChrome>();

    final TextEditingController textController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.unfocus();
    });

    void filterSongs() {
      var query = textController.text.toLowerCase();

      if (query.isEmpty) {
        playerController.songSearchList.clear();
      } else {
        playerController.songSearchList.value =
            playerController.songAppList.where((song) {
          return song.title.toLowerCase().contains(query) ||
              sharedController
                  .getArtist(song.id, song.artist!)
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
          backgroundColor: AppColors.current().background,
          systemOverlayStyle: chromeController.loadThemeByType(
            ThemeTypes.topOneBottomTwo,
          ),
          leading: GestureDetector(
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
          title: TextField(
            cursorHeight: 28.0,
            controller: textController,
            focusNode: focusNode,
            style: Theme.of(context).textTheme.titleMedium,
            cursorColor: AppColors.current().text,
            decoration: InputDecoration(
              fillColor: AppColors.current().surface,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                borderSide: BorderSide(
                  color: AppColors.current().primary,
                  width: 2.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: 'app_search'.tr,
              labelStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Obx(
              () => playerController.songSearchList.isEmpty
                  ? const Space(size: 0)
                  : GestureDetector(
                      onTap: () {
                        focusNode.unfocus();
                      },
                      child: musicList(
                        songs: playerController.songSearchList,
                        selectiontype: SelectionTypes.add,
                      ),
                    ),
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => playerController.songAppList.isEmpty
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
