import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../shared/utils/subtitle_style.dart';
import '../../shared/utils/title_style.dart';
import '../../core/controllers/player.dart';
import '../../routes/app_routes.dart';
import '../utils/functions/get_artist.dart';

class MusicList extends StatefulWidget {
  final List<SongModel> songs;

  const MusicList({super.key, required this.songs});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playerController = Get.put(PlayerController());
    final playerStateController = Get.find<PlayerStateController>();

    return Obx(
      () {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.songs.length,
          itemBuilder: (BuildContext context, int index) {
            var song = widget.songs[index];
            final imagePath = playerStateController.imageCache[song.id];

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
                leading: imagePath == null
                    ? const SizedBox(
                        width: 50.0,
                        height: 50.0,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                onTap: () {
                  if (playerStateController.songList != widget.songs) {
                    playerController.songLoad(widget.songs, index);
                  } else {
                    playerController.playSong(index);
                  }
                  Get.toNamed(AppRoutes.details);
                },
              ),
            );
          },
        );
      },
    );
  }
}
