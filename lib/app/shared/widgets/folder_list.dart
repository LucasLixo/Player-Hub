import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/routes/app_routes.dart';
// import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';

class FolderList extends StatelessWidget {
  const FolderList({super.key});

  @override
  Widget build(BuildContext context) {
    final playerStateController = Get.find<PlayerStateController>();

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: playerStateController.folderList.length,
      itemBuilder: (BuildContext context, int index) {
        final title = playerStateController.folderList[index];
        final songs = playerStateController.folderListSongs[title];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            tileColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
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
            // leading: Icon(
            //   Icons.folder,
            //   color: AppColors.text,
            //   size: 32,
            // ),
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
          ),
        );
      },
    );
  }
}
