import 'package:flutter/material.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

Widget playlistMode() {
  final PlayerController controller = Get.find<PlayerController>();

  return GestureDetector(
    onTap: () async {
      await controller.togglePlaylist();
    },
    child: Obx(() {
      IconData icon;
      switch (AppShared.getShared(SharedAttributes.playlistMode)) {
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
