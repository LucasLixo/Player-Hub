import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/components/pause_play.dart';
import 'package:player/components/style_text.dart';
import 'package:player/controllers/player_controller.dart';
import 'package:player/screens/player.dart';
import 'package:player/utils/const.dart';

class Shortcut extends StatefulWidget {
  const Shortcut({super.key});

  @override
  State<Shortcut> createState() => _ShortcutState();
}

class _ShortcutState extends State<Shortcut> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();

    return Obx(
      () {
        final song = playerController.songs[playerController.playerIndex.value];
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
                style: styleText(fontFamily: bold, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                song.artist!.trim(),
                style: styleText(fontFamily: regular, fontSize: 16),
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
                child: const AnimatedPausePlay(),
              ),
              onTap: () {
                Get.to(
                  () => const Player(),
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
