import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/shared/dialog/dialog_bool.dart';
import 'package:player_hub/app/shared/dialog/dialog_text_field.dart';

Future<void> crudPlaylist({
  required String playlistTitle,
}) async {
  final PlayerController playerController = Get.find<PlayerController>();

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
                playlistTitle,
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
                'crud_sheet9'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(
                Icons.edit,
                color: AppColors.current().text,
                size: 28,
              ),
              onTap: () async {
                Get.back();
                final String? result = await dialogTextField(
                  title: 'crud_sheet9'.tr,
                  description: playlistTitle,
                );
                if (result != null) {
                  await playerController.renamePlaylist(
                    playlistTitle,
                    result,
                  );
                }
              },
            ),
            ListTile(
              tileColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              title: Text(
                'crud_sheet7'.tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(
                Icons.delete,
                color: AppColors.current().text,
                size: 28,
              ),
              onTap: () async {
                final bool? result = await dialogBool(
                  title: 'crud_sheet7'.tr,
                );
                Get.back();
                if (result == true) {
                  await playerController.removePlaylist(playlistTitle);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
