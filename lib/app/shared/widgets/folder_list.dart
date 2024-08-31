import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';

class FolderList extends StatelessWidget {
  const FolderList({super.key});

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();
    final playerStateController = Get.find<PlayerStateController>();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: playerStateController.folderList.length,
      itemBuilder: (BuildContext context, int index) {
        var title = playerStateController.folderList[index];
        var songs = playerController.getSongsFromFolder(title);

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
              songs.length.toString(),
              style: subtitleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: Icon(
              Icons.folder,
              color: AppColors.text,
              size: 32,
            ),
            onTap: () {
              Get.toNamed(AppRoutes.playlist, arguments: {
                'title': title,
                'songs': songs,
              });
            },
          ),
        );
      },
    );
  }
}
