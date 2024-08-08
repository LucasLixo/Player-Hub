import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../core/player/player_export.dart';
import '../../shared/utils/subtitle_style.dart';
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
        final song = playerStateController
            .songList[playerStateController.songIndex.value];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: ListTile(
            tileColor: colorBackground,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              song.title.trim(),
              style: titleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artist!.trim(),
              style: subtitleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 32,
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
                color: Colors.white,
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
