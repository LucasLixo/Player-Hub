import 'package:flutter/material.dart';
// import 'package:player_hub/app/core/controllers/player.dart';
// import 'package:get/instance_manager.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_rx/get_rx.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:player_hub/app/core/enums/shared_attibutes.dart';
// import 'package:player_hub/app/core/static/app_shared.dart';
// import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:helper_hub/src/theme_widget.dart';

Future<void> crudPlaylist(
  BuildContext context, {
  required String folder,
}) async {
  // final PlayerController playerController = Get.find<PlayerController>();

  await showModalBottomSheet(
    context: context,
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
