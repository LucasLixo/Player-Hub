import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

Future<void> crudAddPlaylist({
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
              Divider(
                color: AppColors.current().textOpacity,
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: controller.playlistList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String title = controller.playlistList[index];

                    return GestureDetector(
                      onTap: () {
                        controller.addSongsPlaylist(title, songs);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
