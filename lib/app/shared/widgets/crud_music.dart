import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:share_plus/share_plus.dart';

Future<void> crudMusic({
  required SongModel song,
}) async {
  Future<void> sharedFiles() async {
    final ShareResult result = await Share.shareXFiles(
      [XFile(song.data, name: song.displayNameWOExt)],
      text: AppShared.getTitle(song.id, song.title),
    );

    if (result.status == ShareResultStatus.success) {}
  }

  await showModalBottomSheet(
    context: Get.context!,
    backgroundColor: AppColors.current().background,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Space(
              size: 12,
              orientation: Axis.vertical,
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
            const Space(
              size: 12,
              orientation: Axis.vertical,
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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
                await sharedFiles();
              },
            ),
          ],
        ),
      );
    },
  );
}
