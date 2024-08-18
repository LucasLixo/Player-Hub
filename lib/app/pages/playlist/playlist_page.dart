import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../shared/widgets/music_list.dart';
import '../../shared/widgets/shortcut.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../core/controllers/player.dart';

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
            18,
            AppColors.text,
            FontWeight.normal,
            FontStyle.normal,
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
            : const Shortcut(),
      ),
    );
  }
}
