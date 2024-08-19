import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/app/core/app_constants.dart';
import 'dart:math';

import '../../shared/utils/subtitle_style.dart';
import '../../shared/utils/title_style.dart';
import '../../core/controllers/player.dart';
import '../../routes/app_routes.dart';

class MusicList extends StatelessWidget {
  final List<SongModel> songs;

  const MusicList({super.key, required this.songs});

  String getRandomImage() {
    final random = Random();
    final index = random.nextInt(imagePaths.length);
    return imagePaths[index];
  }

  @override
  Widget build(BuildContext context) {
    final playerController = Get.put(PlayerController());
    final playerStateController = Get.put(PlayerStateController());

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (BuildContext context, int index) {
        var song = songs[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            tileColor: Colors.transparent,
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
            leading: ClipOval(
              child: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Image.asset(
                  getRandomImage(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              if (playerStateController.songList != songs) {
                playerController.songLoad(songs, index);
              } else {
                playerController.playSong(index);
              }
              Get.toNamed(AppRoutes.details);
            },
          ),
        );
      },
    );
  }
}
