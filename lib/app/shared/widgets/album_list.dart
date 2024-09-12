import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    final playerStateController = Get.find<PlayerStateController>();
    final playerController = Get.find<PlayerController>();

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: playerStateController.albumList.length,
      itemBuilder: (BuildContext context, int index) {
        final album = playerStateController.albumList[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            tileColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            title: Text(
              album.album,
              style: titleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "${album.numOfSongs.toString()} - ${album.artist}",
              style: subtitleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: Icon(
              Icons.playlist_play,
              color: AppColors.text,
              size: 36,
            ),
            onTap: () async {
              final songs = await playerController.queryAudiosFromAlbum(
                albumId: album.id,
              );
              print(album);
              print(songs);
              Get.toNamed(AppRoutes.playlist, arguments: {
                'title': album.album,
                'songs': songs,
              });
            },
          ),
        );
      },
    );
  }
}
