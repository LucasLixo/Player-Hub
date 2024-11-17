import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/services.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';

Widget albumList({
  required List<AlbumModel> albumList,
  required Map<String, List<SongModel>> albumSongs,
  required bool isAlbumArtist,
}) {
  return ListView.builder(
    physics: const ClampingScrollPhysics(),
    itemCount: albumSongs.length,
    itemBuilder: (BuildContext context, int index) {
      final artist = albumList[index].artist! == '<unknown>' ? '' : '';
      final title = isAlbumArtist
          ? (artist.isNotEmpty ? artist : albumList[index].album)
          : albumList[index].album;
      final songs = albumSongs[albumList[index].album];

      return ListTile(
        tileColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        minVerticalPadding: 4.0,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          songs!.length.toString(),
          style: Theme.of(context).textTheme.labelMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: FutureBuilder<Uint8List>(
          future: AppManifest.getImageArray(
            id: songs[0].id,
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
        onTap: () async {
          await Get.toNamed(AppRoutes.playlist, arguments: {
            'playlistTitle': title,
            'playlistList': songs,
            'playlistType': SelectionTypes.none,
          });
        },
      );
    },
  );
}
