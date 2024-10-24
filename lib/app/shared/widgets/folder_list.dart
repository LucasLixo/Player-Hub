import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/types/app_manifest.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';

class FolderList extends GetView<PlayerController> with AppManifest {
  FolderList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: controller.folderList.length,
      itemBuilder: (BuildContext context, int index) {
        final title = controller.folderList[index];
        final songs = controller.folderListSongs[title];

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            tileColor: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
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
              future: getImageArray(
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
              await Get.toNamed(AppRoutes.playlist, arguments: {
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
