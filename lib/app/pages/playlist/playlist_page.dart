import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playerhub/app/shared/widgets/music_list.dart';
import 'package:playerhub/app/shared/widgets/shortcut.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/controllers/player.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistTitle;
  final List<SongModel> playlistList;

  const PlaylistPage({
    super.key,
    required this.playlistTitle,
    required this.playlistList,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  @override
  void initState() {
    super.initState();
    if (widget.playlistTitle == 'playlist1'.tr) {
      playerStateController.isListRecent.value = true;
    }
  }

  @override
  void dispose() {
    if (widget.playlistTitle == 'playlist1'.tr) {
      playerStateController.isListRecent.value = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
          widget.playlistTitle,
          style: dynamicStyle(
            fontSize: 18,
            fontColor: AppColors.text,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: MusicList(songs: widget.playlistList),
      ),
      bottomNavigationBar: Obx(
        () => playerStateController.songAllList.isEmpty
            ? const SizedBox.shrink()
            : const SafeArea(
                child: Shortcut(),
              ),
      ),
    );
  }
}
