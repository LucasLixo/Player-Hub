import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/image_quality.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/shared/more_vert/crud_music.dart';

// ==================================================
Widget musicList({
  required List<SongModel> songs,
  ListTile? first,
  SelectionTypes selectiontype = SelectionTypes.none,
  String? selectionTitle,
}) {
  final PlayerController playerController = Get.find<PlayerController>();
  final AppShared sharedController = Get.find<AppShared>();

  return ListView.builder(
    physics: const ClampingScrollPhysics(),
    itemCount: songs.length + 1,
    itemBuilder: (BuildContext context, int index) {
      if (index == 0) {
        return first ?? const SizedBox.shrink();
      }

      final int myIndex = index - 1;
      final SongModel song = songs[myIndex];

      return ListTile(
        tileColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 2.0),
        title: Text(
          sharedController.getTitle(
            song.id,
            song.title,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          sharedController.getArtist(song.id, song.artist!),
          style: Theme.of(context).textTheme.labelMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FutureBuilder<Uint8List>(
            future:
                AppManifest.getImageArray(id: song.id, type: ImageQuality.low),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError ||
                  !snapshot.hasData) {
                return const SizedBox(
                  width: 50.0,
                  height: 50.0,
                );
              } else {
                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: 50.0,
                  height: 50.0,
                );
              }
            },
          ),
        ),
        trailing: GestureDetector(
          onTap: () async {
            await crudMusic(
              song: song,
            );
          },
          child: Icon(
            Icons.more_vert,
            color: AppColors.current().text,
          ),
        ),
        onTap: () async {
          if (playerController.songList != songs) {
            await playerController.songLoad(songs, myIndex);
          } else {
            await playerController.playSong(myIndex);
          }
          await Get.toNamed(AppRoutes.details);
        },
        onLongPress: () async {
          switch (selectiontype) {
            case SelectionTypes.none:
              break;
            case SelectionTypes.add:
              playerController.songSelectionList.clear();
              playerController.songSelectionList.addAll(songs);
              await Get.toNamed(AppRoutes.selectionAdd, arguments: {
                'selectionTitle': selectionTitle,
                'selectionIndex': myIndex,
              });
              break;
            case SelectionTypes.remove:
              await Get.toNamed(AppRoutes.selectionRemove, arguments: {
                'selectionTitle': selectionTitle,
                'selectionIndex': myIndex,
              });
              break;
          }
        },
      );
    },
  );
}
