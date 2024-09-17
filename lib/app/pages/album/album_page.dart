import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';

class AlbumPage extends StatefulWidget {
  final String albumTitle;
  final List<AlbumModel> albumList;
  final Map<String, List<SongModel>> albumSongs;
  final String albumNotTitle;

  const AlbumPage({
    super.key,
    required this.albumTitle,
    required this.albumList,
    required this.albumSongs,
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
      body: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: widget.albumSongs.length,
        itemBuilder: (BuildContext context, int index) {
          final title = widget.albumList[index].album;
          final songs = widget.albumSongs[title];

          return ListTile(
            tileColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            minVerticalPadding: 4.0,
            title: Text(
              title,
              style: titleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              songs!.length.toString(),
              style: subtitleStyle(),
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
            onTap: () async {
              Get.toNamed(AppRoutes.playlist, arguments: {
                'title': title,
                'songs': songs,
              });
            },
          );
        },
      ),
    );
  }
}
