import 'package:flutter/material.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

Widget playlistMode() {
  final PlayerController playerController = Get.find<PlayerController>();
  final AppShared sharedController = Get.find<AppShared>();

  return GestureDetector(
    onTap: () async {
      await playerController.togglePlaylist();
    },
    child: Obx(() {
      IconData icon;
      switch (sharedController.getShared<int>(SharedAttributes.playlistMode)) {
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
