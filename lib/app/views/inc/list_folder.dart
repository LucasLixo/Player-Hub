import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/app/core/app_colors.dart';
import 'package:player/app/routes/app_routes.dart';

import '../../core/player/player_export.dart';
import '../../shared/utils/title_style.dart';

class ListFolderView extends StatefulWidget {
  const ListFolderView({super.key});

  @override
  _ListFolderViewState createState() => _ListFolderViewState();
}

class _ListFolderViewState extends State<ListFolderView> {
  @override
  Widget build(BuildContext context) {
    final playerStateController = Get.put(PlayerStateController());
    final playerController = Get.put(PlayerController());

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: playerStateController.folderList.length,
      itemBuilder: (BuildContext context, int index) {
        var title = playerStateController.folderList[index];
        var songs = playerController.getSongsFromFolder(title);

        return Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: colorBackground,
            title: Text(
              title,
              style: titleStyle(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
