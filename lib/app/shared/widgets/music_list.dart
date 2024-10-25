import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/types/app_manifest.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/shared/widgets/crud_sheet.dart';
import 'package:player_hub/app/core/static/app_colors.dart';

class MusicList extends GetView<PlayerController> with AppManifest {
  final List<SongModel> songs;

  MusicList({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (BuildContext context, int index) {
        final song = songs[index];

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
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            AppShared.getArtist(song.id, song.artist!),
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: FutureBuilder<Uint8List>(
            future: getImageArray(
              id: song.id,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: 50.0,
                  height: 50.0,
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const SizedBox(
                  width: 50.0,
                  height: 50.0,
                );
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                );
              }
            },
          ),
          trailing: InkWell(
            onTap: () {
              crudSheet(context, song);
            },
            child: Icon(
              Icons.more_vert,
              color: AppColors.current().text,
            ),
          ),
          onTap: () async {
            if (controller.songList != songs) {
              await controller.songLoad(songs, index);
            } else {
              await controller.playSong(index);
            }
            await Get.toNamed(AppRoutes.details);
          },
        );
      },
    );
  }
}
