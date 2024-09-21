import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/player.dart';

class PlaylistMode extends GetView<PlayerController> {
  const PlaylistMode({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.togglePlaylist();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Obx(() {
        final playlistMode = AppShared.playlistModeValue.value;

        IconData icon;
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
          default:
            icon = Icons.error;
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
