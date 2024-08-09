import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../shared/widgets/music_list.dart';
import '../shared/widgets/shortcut.dart';
import '../shared/utils/dynamic_style.dart';
import '../core/app_colors.dart';
import '../core/player/player_export.dart';

class PlaylistView extends StatefulWidget {
  final String playlistTitle;
  final List<SongModel> playlistList;

  const PlaylistView({
    super.key,
    required this.playlistTitle,
    required this.playlistList,
  });

  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  final playerController = Get.find<PlayerController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playerController.songLoad(widget.playlistList);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playerController.resetPlaylist();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackgroundDark,
      appBar: AppBar(
        backgroundColor: colorBackgroundDark,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: const Icon(
            Icons.arrow_back_ios,
            color: colorWhite,
            size: 26,
          ),
        ),
        title: Text(
          widget.playlistTitle,
          style: dynamicStyle(
            18,
            colorWhite,
            FontWeight.normal,
            FontStyle.normal,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: MusicList(songs: widget.playlistList),
            ),
          ),
          const Shortcut(),
        ],
      ),
    );
  }
}
