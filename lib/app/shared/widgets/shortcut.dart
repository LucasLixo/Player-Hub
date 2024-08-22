import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../core/controllers/player.dart';
import '../../shared/utils/subtitle_style.dart';
import '../../shared/utils/title_style.dart';
import '../meta/get_artist.dart';

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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListTile(
            tileColor: AppColors.surface,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              song.title,
              style: titleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              getArtist(artist: song.artist!),
              style: subtitleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
            trailing: Transform.scale(
              scale: 1.5,
              child: IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _controller,
                ),
                onPressed: _togglePlayPause,
                color: AppColors.text,
              ),
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
