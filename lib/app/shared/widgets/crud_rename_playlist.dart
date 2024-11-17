import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

Future<void> crudRenamePlaylist({
  required String playlistTitle,
}) async {
  await showDialog(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final PlayerController controller = Get.find<PlayerController>();

      final TextEditingController textController = TextEditingController();
      final RxString title = ''.obs;

      textController.addListener(() {
        title.value = textController.text;
      });

      textController.text = playlistTitle;

      return Dialog(
        backgroundColor: AppColors.current().surface,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'crud_sheet9'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                style: Theme.of(context).textTheme.titleMedium,
                cursorColor: AppColors.current().text,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.current().text),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.current().background,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'crud_sheet_dialog_2'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(() {
                    return InkWell(
                      onTap: () async {
                        String currentTitle = title.value.trim();
                        if (currentTitle.isNotEmpty) {
                          await controller.renamePlaylist(
                            playlistTitle,
                            currentTitle,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: AppColors.current().primary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'crud_sheet_dialog_1'.tr,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      );
    },
  );
}
