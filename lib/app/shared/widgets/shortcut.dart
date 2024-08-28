import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../core/controllers/player.dart';
import '../../shared/utils/title_style.dart';

class Shortcut extends StatefulWidget {
  const Shortcut({super.key});

  @override
  State<Shortcut> createState() => _ShortcutState();
}

class _ShortcutState extends State<Shortcut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    playerController.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _togglePlayPause() async {
    if (playerStateController.isPlaying.value) {
      await playerController.pauseSong();
    } else {
      await playerController.playSong(playerStateController.songIndex.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (playerStateController.songList.isEmpty ||
            playerStateController.songIndex.value >=
                playerStateController.songList.length) {
          return const SizedBox.shrink();
        }

        final song = playerStateController
            .songList[playerStateController.songIndex.value];
        final imagePath = playerStateController.imageCache[song.id];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          margin: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
          child: ListTile(
            tileColor: AppColors.surface,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(55),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            title: Text(
              song.title,
              style: titleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: ClipOval(
              child: imagePath != null
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 50.0,
                    )
                  : const SizedBox(
                      width: 50.0,
                      height: 50.0,
                    ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    playerController.previousSong();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Icon(
                    Icons.skip_previous_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    _togglePlayPause();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _controller,
                    size: 32,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    playerController.nextSong();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Icon(
                    Icons.skip_next_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            onTap: () {
              Get.toNamed(AppRoutes.details);
            },
          ),
        );
      },
    );
  }
}
