import 'package:flutter/material.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:toastification/toastification.dart';

void myToastification(BuildContext context, String text, IconData icon) {
  toastification.show(
    context: context,
    title: Text(
      text,
      style: titleStyle(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    primaryColor: AppColors.primary,
    backgroundColor: AppColors.surface,
    type: ToastificationType.info,
    icon: Icon(
      icon,
      color: AppColors.primary,
      size: 32,
    ),
    style: ToastificationStyle.minimal,
    autoCloseDuration: const Duration(milliseconds: 1400),
  );
}
