import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:helper_hub/src/theme_widget.dart';

Future<void> crudPlaylist({
  required String folder,
}) async {
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
                folder,
                style: Theme.of(context).textTheme.headlineMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Space(
              size: 12,
              orientation: Axis.vertical,
            ),
            const ListTile(
              tileColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
            ),
          ],
        ),
      );
    },
  );
}
