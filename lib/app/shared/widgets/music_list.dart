import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/shared/widgets/crud_sheet.dart';

class MusicList extends StatefulWidget {
  final List<SongModel> songs;

  const MusicList({super.key, required this.songs});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  
  @override
  Widget build(BuildContext context) {
    final playerController = Get.put(PlayerController());
    final playerStateController = Get.find<PlayerStateController>();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.songs.length,
      itemBuilder: (BuildContext context, int index) {
        final song = widget.songs[index];
        final imageFile = playerStateController.imageCache[song.id];

        return ListTile(
          tileColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 2.0),
          title: Text(
            AppShared.getTitle(
              song.id,
              song.title,
            ),
            style: titleStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            AppShared.getArtist(song.id, song.artist!),
            style: subtitleStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageFile != null
                ? Image.file(
                    File(imageFile),
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
            if (playerStateController.songList != widget.songs) {
              playerController.songLoad(widget.songs, index);
            } else {
              playerController.playSong(index);
            }
            Get.toNamed(AppRoutes.details);
          },
        );
      },
    );
  }
}
