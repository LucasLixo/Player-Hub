import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playerhub/app/core/app_colors.dart';

Future<String?> showWindowConfirm({
  required String title,
  required String? subtitle,
  required VoidCallback confirm,
  required VoidCallback? cancel,
  bool dismissible = false,
}) async {
  return showDialog<String>(
    context: Get.context!,
    barrierDismissible: dismissible,
    builder: (BuildContext context) => Dialog(
      backgroundColor: AppColors.current().surface,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle != null
                ? Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: cancel != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (cancel != null)
                  InkWell(
                    onTap: cancel,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.current().background,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'crud_sheet_dialog_1'.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: confirm,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      color: AppColors.current().background,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'crud_sheet_dialog_2'.tr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
