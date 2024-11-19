import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:player_hub/app/shared/dialog/dialog_text_field.dart';

Future<void> addPlaylist({
  required List<SongModel> songs,
}) async {
  await showDialog(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final PlayerController controller = Get.find<PlayerController>();

      return Dialog(
        backgroundColor: AppColors.current().background,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'crud_sheet1'.tr,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: Obx(() {
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: controller.playlistList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: () async {
                            final String? result = await dialogTextField(
                              title: 'crud_sheet6'.tr,
                              description: '',
                            );
                            if (result != null) {
                              controller.addPlaylist(result);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: AppColors.current().primary,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'crud_sheet6'.tr,
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }

                      final int myIndex = index - 1;
                      final String title = controller.playlistList[myIndex];

                      return GestureDetector(
                        onTap: () {
                          controller.addSongsPlaylist(title, songs);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            color: AppColors.current().surface,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
