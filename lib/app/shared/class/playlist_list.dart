import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/routes/app_routes.dart';

class PlaylistList extends GetView<PlayerController> {
  const PlaylistList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          if (controller.playlistList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'home_tab2'.tr,
                style: Get.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ...controller.playlistList.map((title) {
            return Obx(() {
              final Rx<List<SongModel>?> songs =
                  controller.playlistListSongs[title].obs;

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
                  songs.value?.length.toString() ?? '0',
                  style: Get.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: songs.value?.isNotEmpty ?? false
                      ? FutureBuilder<Uint8List>(
                          future:
                              AppManifest.getImageArray(id: songs.value![0].id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
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
                        )
                      : const SizedBox(
                          width: 50.0,
                          height: 50.0,
                        ),
                ),
                trailing: InkWell(
                  child: Icon(
                    Icons.more_vert,
                    color: AppColors.current().text,
                    size: 32,
                  ),
                  onTap: () async {},
                ),
                onTap: () async {
                  if (songs.value?.isNotEmpty ?? false) {
                    await Get.toNamed(AppRoutes.playlist, arguments: {
                      'playlistTitle': title,
                      'playlistList': songs.value ?? <SongModel>[],
                      'playlistType': SelectionTypes.remove,
                    });
                  }
                },
              );
            });
          }),
        ],
      );
    });
  }
}
