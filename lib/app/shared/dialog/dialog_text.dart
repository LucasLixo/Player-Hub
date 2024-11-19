import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

Future<void> dialogText({
  required String title,
  required String description,
}) async {
  return await showDialog<void>(
    context: Get.context!,
    barrierDismissible: true,
    builder: (BuildContext context) {
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
              Text(
                description,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Text(
                        'crud_sheet_dialog_2'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Obx(() {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
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
            ],
          ),
        ),
      );
    },
  );
}
