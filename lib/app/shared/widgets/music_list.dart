import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../shared/utils/subtitle_style.dart';
import '../../shared/utils/title_style.dart';
import '../../core/controllers/player.dart';
import '../../routes/app_routes.dart';
import '../../core/app_colors.dart';
import '../utils/crud_sheet.dart';
import '../meta/get_artist.dart';

class MusicList extends StatelessWidget {
  final List<SongModel> songs;

  const MusicList({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    final playerController = Get.put(PlayerController());
    final playerStateController = Get.find<PlayerStateController>();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (BuildContext context, int index) {
        var song = songs[index];
        final imagePath = playerStateController.imageCache[song.id];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            tileColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
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
            trailing: InkWell(
              onTap: () {
                crudSheet(context, song);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.more_vert,
                size: 30,
                color: AppColors.text,
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
