import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/player/player_export.dart';
import '../../shared/widgets/music_list.dart';

class ListMusicView extends StatefulWidget {
  const ListMusicView({super.key});

  @override
  _ListMusicViewState createState() => _ListMusicViewState();
}

class _ListMusicViewState extends State<ListMusicView> {
  @override
  Widget build(BuildContext context) {
    final playerStateController = Get.put(PlayerStateController());

    return MusicList(songs: playerStateController.songAllList);
  }
}
