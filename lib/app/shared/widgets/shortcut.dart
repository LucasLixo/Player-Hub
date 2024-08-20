import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../core/controllers/player.dart';
import '../../shared/utils/subtitle_style.dart';
import '../../shared/utils/title_style.dart';
import '../../core/controllers/inc/get_image.dart';
import '../../core/controllers/inc/get_artist.dart';

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

  Future<String> getImageForSong(int songId) async {
    return await getImage(id: songId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (playerStateController.songList.isEmpty ||
            playerStateController.songIndex.value >=
                playerStateController.songList.length) {
          return Center(
            child: Text(
              '...',
              style: titleStyle(),
            ),
          );
        }

        final song = playerStateController
            .songList[playerStateController.songIndex.value];

        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: FutureBuilder<String>(
            future: getImageForSong(song.id),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError) {
                return const SizedBox.shrink();
              } else {
                return ListTile(
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
                    child: Image.file(
                      File(snapshot.data!),
                      fit: BoxFit.cover,
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
                );
              }
            },
          ),
        );
      },
    );
  }
}
