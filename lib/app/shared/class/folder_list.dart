import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/ignores_load.dart';
import 'package:player_hub/app/core/enums/image_quality.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/enums/updated_load.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class FolderList extends GetView<PlayerController> {
  const FolderList({super.key});

  @override
  Widget build(BuildContext context) {
    final AppShared sharedController = Get.find<AppShared>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.folderList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'home_tab5'.tr,
                style: Get.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ...controller.folderList.map((title) {
            final List<SongModel>? songs = controller.folderListSongs[title];

            return ListTile(
              tileColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 2.0),
              title: Text(
                title,
                style: Get.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                songs!.length.toString(),
                style: Get.textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FutureBuilder<Uint8List>(
                  future: AppManifest.getImageArray(
                    id: songs[0].id,
                    type: ImageQuality.low,
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
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: 50.0,
                      );
                    }
                  },
                ),
              ),
              trailing: Obx(() {
                List<String> listFolderIgnore = List<String>.from(
                  sharedController
                      .getShared<List<String>>(SharedAttributes.ignoreFolder),
                );

                final RxBool isIgnored = listFolderIgnore.contains(title).obs;

                return GestureDetector(
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
                    await sharedController.setShared(
                      SharedAttributes.ignoreFolder,
                      listFolderIgnore,
                    );
                    await controller.songAllLoad(
                      controller.songAllList,
                      typeLoad: [
                        UpdatedTypeLoad.folder,
                      ],
                      typeInore: [
                        IgnoresLoad.folders,
                      ],
                    );
                    controller.songList.clear();
                    controller.songList.addAll(controller.songAppList);
                  },
                );
              }),
              onTap: () async {
                await Get.toNamed(AppRoutes.playlist, arguments: {
                  'playlistTitle': title,
                  'playlistList': songs,
                  'playlistType': SelectionTypes.add,
                });
              },
            );
          }),
        ],
      );
    });
  }
}
