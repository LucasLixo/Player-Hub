import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/instance_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/core/types/app_manifest.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';

class FolderList extends GetView<PlayerController> with AppManifest {
  FolderList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: controller.folderList.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Text(
              'home_tab5'.tr,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }

        final int myIndex = index - 1;
        final String title = controller.folderList[myIndex];
        final List<SongModel>? songs = controller.folderListSongs[title];

        return ListTile(
          tileColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 2.0),
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
          trailing: Obx(() {
            List<String> listFolderIgnore =
                AppShared.getShared(SharedAttributes.ignoreFolder)
                    as List<String>;

            final RxBool isIgnored = listFolderIgnore.contains(title).obs;

            return InkWell(
              child: Icon(
                isIgnored.value ? Icons.visibility_off : Icons.visibility,
                color: AppColors.current().text,
                size: 32,
              ),
              onTap: () async {
                if (isIgnored.value) {
                  listFolderIgnore.remove(title);
                } else {
                  listFolderIgnore.add(title);
                }
                await AppShared.setShared(
                  SharedAttributes.ignoreFolder,
                  listFolderIgnore,
                );
                await controller.songAllLoad(controller.songAllList);
                controller.songList.clear();
                controller.songList.addAll(controller.songAllList);
              },
            );
          }),
          onTap: () async {
            await Get.toNamed(AppRoutes.playlist, arguments: {
              'playlistTitle': title,
              'playlistList': songs,
            });
          },
        );
      },
    );
  }
}
