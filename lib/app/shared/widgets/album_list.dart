import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/routes/app_routes.dart';

class AlbumList extends GetView<PlayerStateController> {
  final List<AlbumModel> albumList;
  final Map<String, List<SongModel>> albumSongs;
  final bool isAlbumArtist;

  const AlbumList({
    super.key,
    required this.albumList,
    required this.albumSongs,
    required this.isAlbumArtist,
  });

  @override
  Widget build(BuildContext context) {
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
            future: AppShared.getImageArray(
              id: songs[0].id,
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
          onTap: () {
            Get.toNamed(AppRoutes.playlist, arguments: {
              'playlistTitle': title,
              'playlistList': songs,
            });
          },
        );
      },
    );
  }
}
