import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../shared/utils/subtitle_style.dart';
import '../../shared/utils/title_style.dart';
import '../../core/controllers/player.dart';
import '../../routes/app_routes.dart';
import '../../core/controllers/inc/get_image.dart';
import '../../core/app_colors.dart';

class MusicList extends StatelessWidget {
  final List<SongModel> songs;

  const MusicList({super.key, required this.songs});

  Future<String> getImageForSong(int songId) async {
    return await getImage(id: songId);
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

        return FutureBuilder<String>(
          future: getImageForSong(song.id),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError) {
              return const SizedBox.shrink();
            } else {
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
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(snapshot.data!),
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 50.0,
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
            }
          },
        );
      },
    );
  }
}
