import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/shared/widgets/add_playlist.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/instance_manager.dart';

Future<void> crudMusic({
  required SongModel song,
}) async {
  final AppShared sharedController = Get.find<AppShared>();

  Future<void> sharedFiles() async {
    final ShareResult result = await Share.shareXFiles(
      [XFile(song.data, name: song.displayNameWOExt)],
      text: sharedController.getTitle(song.id, song.title),
    );

    if (result.status == ShareResultStatus.success) {}
  }

  await showModalBottomSheet(
    context: Get.context!,
    backgroundColor: AppColors.current().background,
    builder: (BuildContext context) {
      return SizedBox(
        height: Get.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 12,
            ),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Text(
                song.title,
                style: Theme.of(context).textTheme.headlineMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ListTile(
              tileColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              title: Text(
                'crud_sheet3'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(
                Icons.edit,
                color: AppColors.current().text,
                size: 28,
              ),
              onTap: () async {
                Get.back();
                await Get.toNamed(AppRoutes.edit, arguments: {
                  'song': song,
                });
              },
            ),
            ListTile(
              tileColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              title: Text(
                'crud_sheet4'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(
                Icons.share,
                color: AppColors.current().text,
                size: 28,
              ),
              onTap: () async {
                Get.back();
                await sharedFiles();
              },
            ),
            ListTile(
              tileColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              title: Text(
                'crud_sheet1'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(
                Icons.add,
                color: AppColors.current().text,
                size: 28,
              ),
              onTap: () async {
                Get.back();
                await addPlaylist(songs: [song]);
              },
            ),
          ],
        ),
      );
    },
  );
}
