import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:playerhub/app/shared/widgets/center_text.dart';

class AlbumPage extends StatefulWidget {
  final int albumType;
  final String albumTitle;
  final List<AlbumModel> albumList;
  final String albumNotTitle;

  const AlbumPage({
    super.key,
    required this.albumType,
    required this.albumTitle,
    required this.albumList,
    required this.albumNotTitle,
  });

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final playerStateController = Get.find<PlayerStateController>();
  final playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: InkWell(
          onTap: () => Get.back(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text,
            size: 26,
          ),
        ),
        title: Text(
          widget.albumTitle,
          style: dynamicStyle(
            fontSize: 20,
            fontColor: AppColors.text,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: Obx(() {
        if (widget.albumList.isEmpty) {
          return CenterText(title: widget.albumNotTitle);
        } else {
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: widget.albumList.length,
            itemBuilder: (BuildContext context, int index) {
              final album = widget.albumList[index];

              return ListTile(
                tileColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                minVerticalPadding: 4.0,
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
                    type: widget.albumType,
                    albumId: album.id,
                  );
                  Get.toNamed(AppRoutes.playlist, arguments: {
                    'title': album.album,
                    'songs': songs,
                  });
                },
              );
            },
          );
        }
      }),
    );
  }
}
