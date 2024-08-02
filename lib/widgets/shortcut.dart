import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/controllers/player_export.dart';
import 'package:player/screens/details.dart';
import 'package:player/utils/colors.dart';
import 'package:player/utils/text_style.dart';

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

    if (playerController.audioPlayer.playing) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Future<void> _togglePlayPause() async {
    if (playerController.audioPlayer.playing) {
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
        return GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              playerController.previousSong();
            } else if (details.delta.dx < 0) {
              playerController.nextSong();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(
                song.title.trim(),
                style: textStyle(fontFamily: bold, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                song.artist!.trim(),
                style: textStyle(fontFamily: regular, fontSize: 16),
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
                Get.to(
                  () => const Details(),
                  transition: Transition.downToUp,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
