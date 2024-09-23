import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playerhub/app/shared/widgets/music_list.dart';
import 'package:playerhub/app/shared/widgets/shortcut.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/controllers/player.dart';

class PlaylistPage extends GetView<PlayerStateController> {
  final String playlistTitle;
  final List<SongModel> playlistList;

  const PlaylistPage({
    super.key,
    required this.playlistTitle,
    required this.playlistList,
  });

  @override
  Widget build(BuildContext context) {
    if (playlistTitle == 'playlist1'.tr) {
      controller.isListRecent.value = true;
    } else {
      controller.isListRecent.value = false;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text,
            size: 26,
          ),
        ),
        title: Text(
          playlistTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: MusicList(songs: playlistList),
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
