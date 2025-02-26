import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/core/enums/theme_types.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/services/app_chrome.dart';
import 'package:player_hub/app/shared/class/shortcut.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/shared/dialog/dialog_bool.dart';
import 'package:player_hub/app/shared/widgets/music_list.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistTitle;
  final List<SongModel>? playlistList;
  final SelectionTypes playlistType;
  final bool isPlaylist;

  const PlaylistPage({
    super.key,
    required this.playlistTitle,
    required this.playlistList,
    required this.playlistType,
    required this.isPlaylist,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final PlayerController playerController = Get.find<PlayerController>();
  final AppChrome chromeController = Get.find<AppChrome>();

  @override
  void initState() {
    super.initState();
    if (widget.playlistTitle == 'playlist1'.tr) {
      playerController.isListRecent.value = true;
    }
  }

  @override
  void dispose() {
    if (widget.playlistTitle == 'playlist1'.tr) {
      playerController.isListRecent.value = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current().background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.current().background,
        systemOverlayStyle: chromeController.loadThemeByType(
          ThemeTypes.topOneBottomTwo,
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.current().text,
            size: 32,
          ),
        ),
        title: Text(
          widget.playlistTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: widget.isPlaylist
            ? [
                GestureDetector(
                  onTap: () async {
                    final bool? result = await dialogBool(
                      title: 'crud_sheet7'.tr,
                    );
                    if (result == true) {
                      await playerController
                          .removePlaylist(widget.playlistTitle);
                    }
                    await Get.offAllNamed(AppRoutes.home);
                  },
                  child: Icon(
                    Icons.delete,
                    color: AppColors.current().text,
                    size: 32,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: widget.playlistList != null
              ? musicList(
                  songs: widget.playlistList!,
                  selectiontype: widget.playlistType,
                  selectionTitle: widget.playlistTitle,
                )
              : const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => playerController.songList.isEmpty
            ? const SizedBox.shrink()
            : const Shortcut(),
      ),
    );
  }
}
