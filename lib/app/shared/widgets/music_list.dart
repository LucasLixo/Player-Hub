import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/shared/utils/meta.dart';

class MusicList extends StatefulWidget {
  final List<SongModel> songs;

  const MusicList({super.key, required this.songs});

  @override
   State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  late List<File> _images;

  @override
  void initState() {
    super.initState();
    _images = widget.songs.map((song) {
      final imagePath = Get.find<PlayerStateController>().imageCache[song.id];
      return imagePath != null ? File(imagePath) : File('');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final playerController = Get.put(PlayerController());
    final playerStateController = Get.find<PlayerStateController>();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.songs.length,
      itemBuilder: (BuildContext context, int index) {
        var song = widget.songs[index];
        final imageFile = _images[index];

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
              child: imageFile.existsSync()
                  ? Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 50.0,
                    )
                  : Container(
                      color: AppColors.surface,
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
  }
}
