import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/player.dart';

class PlaylistMode extends StatefulWidget {
  const PlaylistMode({super.key});

  @override
  _PlaylistModeState createState() => _PlaylistModeState();
}

class _PlaylistModeState extends State<PlaylistMode> {
  final playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        playerController.togglePlaylist();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Obx(() {
        final playlistMode = AppShared.playlistModeValue.value;

        IconData icon = Icons.error;
        switch (playlistMode) {
          case 0:
            icon = Icons.shuffle;
            break;
          case 1:
            icon = Icons.repeat;
            break;
          case 2:
            icon = Icons.repeat_one;
            break;
        }

        return Icon(
          icon,
          size: 30,
          color: Colors.white,
        );
      }),
    );
  }
}
