import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/enums/selection_types.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

List<Widget> playlistList() {
  final PlayerController controller = Get.find<PlayerController>();
  final List<Widget> widgetList = [];

  if (controller.playlistList.isNotEmpty) {
    widgetList.add(
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          'home_tab2'.tr,
          style: Get.textTheme.bodyLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    for (int index = 0; index < controller.playlistList.length; index++) {
      final String title = controller.playlistList[index];
      final List<SongModel> songs =
          controller.playlistListSongs[title] ?? <SongModel>[];

      if (songs.isEmpty) {
        widgetList.add(
          ListTile(
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
              0.toString(),
              style: Get.textTheme.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.current().surface,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            trailing: Obx(() {
              return InkWell(
                child: Icon(
                  Icons.more_vert,
                  color: AppColors.current().text,
                  size: 32,
                ),
                onTap: () async {},
              );
            }),
          ),
        );
      } else {
        widgetList.add(
          ListTile(
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
              songs.length.toString(),
              style: Get.textTheme.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: FutureBuilder<Uint8List>(
              future: AppManifest.getImageArray(id: songs[0].id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError ||
                    !snapshot.hasData) {
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
            trailing: InkWell(
              child: Icon(
                Icons.more_vert,
                color: AppColors.current().text,
                size: 32,
              ),
              onTap: () async {},
            ),
            onTap: () async {
              await Get.toNamed(AppRoutes.playlist, arguments: {
                'playlistTitle': title,
                'playlistList': songs,
                'playlistType': SelectionTypes.remove,
              });
            },
          ),
        );
      }
    }
  }

  return widgetList;
}
