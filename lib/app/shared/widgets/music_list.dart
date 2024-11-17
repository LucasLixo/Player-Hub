import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/shared/widgets/crud_music.dart';

// ==================================================
Widget musicList({
  required List<SongModel> songs,
  ListTile? first,
  SelectionTypes selectiontype = SelectionTypes.none,
  String? selectionTitle,
}) {
  final PlayerController controller = Get.find<PlayerController>();

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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FutureBuilder<Uint8List>(
            future: AppManifest.getImageArray(
              id: song.id,
            ),
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
        trailing: InkWell(
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
          if (controller.songList != songs) {
            await controller.songLoad(songs, myIndex);
          } else {
            await controller.playSong(myIndex);
          }
          await Get.toNamed(AppRoutes.details);
        },
        onLongPress: () async {
          switch (selectiontype) {
            case SelectionTypes.none:
              break;
            case SelectionTypes.add:
              controller.songSelectionList.clear();
              controller.songSelectionList.addAll(songs);
              await Get.toNamed(AppRoutes.selectionAdd, arguments: {
                'selectionTitle': selectionTitle,
                'selectionIndex': [myIndex],
              });
              break;
            case SelectionTypes.remove:
              await Get.toNamed(AppRoutes.selectionRemove, arguments: {
                'selectionTitle': selectionTitle,
                'selectionIndex': [myIndex],
              });
              break;
          }
        },
      );
    },
  );
}
