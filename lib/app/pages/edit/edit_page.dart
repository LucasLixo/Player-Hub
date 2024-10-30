import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/shared/utils/show_toast.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:helper_hub/src/theme_widget.dart';

class EditPage extends GetView<PlayerController> {
  final SongModel song;

  const EditPage({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textControllerTitle = TextEditingController(
      text: AppShared.getTitle(
        song.id,
        song.title,
      ),
    );

    final TextEditingController textControllerArtist = TextEditingController(
      text: AppShared.getArtist(
        song.id,
        song.artist!,
      ),
    );

    Future<void> saveInfo() async {
      await AppShared.setTitle(song.id, textControllerTitle.text);
      await AppShared.setArtist(song.id, textControllerArtist.text);
    }

    return Scaffold(
      backgroundColor: AppColors.current().background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.current().background,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.current().text,
            size: 32,
          ),
        ),
        title: Text(
          AppShared.getTitle(song.id, song.title),
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          InkWell(
            onTap: () async {
              await saveInfo();
              await showToast(
                  "${'edit_save'.tr}: ${AppShared.getTitle(song.id, song.title)}");
            },
            child: Icon(
              Icons.save,
              color: AppColors.current().text,
              size: 32,
            ),
          ),
          const Space(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'edit_title'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: TextField(
                controller: textControllerTitle,
                style: Theme.of(context).textTheme.titleMedium,
                cursorColor: AppColors.current().text,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.current().text),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'edit_artist'.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: TextField(
                controller: textControllerArtist,
                style: Theme.of(context).textTheme.titleMedium,
                cursorColor: AppColors.current().text,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.current().text),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
