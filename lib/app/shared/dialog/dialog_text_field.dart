import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

Future<String?> dialogTextField({
  required String title,
  required String description,
}) async {
  return await showDialog<String>(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final TextEditingController textController = TextEditingController();
      final FocusNode textFocus = FocusNode();

      final RxString text = ''.obs;

      textController.addListener(() {
        text.value = textController.text;
      });
      textFocus.requestFocus();

      textController.text = description;

      return Dialog(
        backgroundColor: AppColors.current().background,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                cursorHeight: 28.0,
                controller: textController,
                focusNode: textFocus,
                style: Theme.of(context).textTheme.titleMedium,
                cursorColor: AppColors.current().text,
                decoration: InputDecoration(
                  fillColor: AppColors.current().surface,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: AppColors.current().primary,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                onSubmitted: (String? value) {
                  String currentTitle = text.value.trim();
                  if (currentTitle.isNotEmpty && value != null) {
                    Get.back(result: currentTitle);
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back(result: null);
                    },
                    child: SizedBox(
                      width: Get.width * 0.3,
                      child: Text(
                        'crud_sheet_dialog_2'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        String currentTitle = text.value.trim();
                        if (currentTitle.isNotEmpty) {
                          Get.back(result: currentTitle);
                        }
                      },
                      child: Container(
                        width: Get.width * 0.3,
                        height: Get.width * 0.1,
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
            ],
          ),
        ),
      );
    },
  );
}
