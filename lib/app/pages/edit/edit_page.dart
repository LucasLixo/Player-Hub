import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/types/app_manifest.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/shared/utils/show_toast.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:share_plus/share_plus.dart';

class EditPage extends GetView<PlayerController> with AppManifest {
  final SongModel song;

  final Rx<File?> imagePicker = Rx<File?>(null);

  final TextEditingController textControllerTitle = TextEditingController();
  final TextEditingController textControllerArtist = TextEditingController();

  EditPage({
    super.key,
    required this.song,
  });

  Future<void> _saveInfo() async {
    try {
      await AppShared.setTitle(song.id, textControllerTitle.text);
      await AppShared.setArtist(song.id, textControllerArtist.text);

      if (imagePicker.value != null) {
        await setImageFile(
          id: song.id,
          bytes: await imagePicker.value!.readAsBytes(),
        );
        await Get.toNamed(AppRoutes.splash, arguments: {
          'function': () async {
            await Future.delayed(const Duration(seconds: 1));
          },
        });
      }

      await showToast(
        "${'edit_save'.tr}: ${AppShared.getTitle(song.id, song.title)}",
      );
    } catch (e) {
      printDebug('Failed to save information.');
    }
  }

  Future<void> _pickerFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg'],
      );

      if (result != null && result.files.single.path != null) {
        imagePicker.value = File(result.files.single.path!);
      }
    } catch (e) {
      printDebug('Failed to pick file.');
    }
  }

  Future<void> _shareImage() async {
    final pathShared =
        imagePicker.value?.path ?? controller.imageCache[song.id];

    if (pathShared != null) {
      await Share.shareXFiles(
        [XFile(pathShared, name: song.displayNameWOExt)],
        text: AppShared.getTitle(song.id, song.title),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    textControllerTitle.text = AppShared.getTitle(song.id, song.title);
    textControllerArtist.text = AppShared.getArtist(song.id, song.artist!);

    final String? imageFile = controller.imageCache[song.id];

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
          song.displayNameWOExt,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          InkWell(
            onTap: () async {
              await _saveInfo();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: imageFile != null
                          ? Obx(() {
                              return Image.file(
                                imagePicker.value ?? File(imageFile),
                                fit: BoxFit.cover,
                                width: 128,
                                height: 128,
                              );
                            })
                          : const SizedBox(
                              width: 128,
                              height: 128,
                            ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Compartilhar',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () async {
                              await _shareImage();
                            },
                            trailing: Icon(
                              Icons.share,
                              size: 32,
                              color: AppColors.current().text,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Trocar Imagem',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () async {
                              await _pickerFile();
                            },
                            trailing: Icon(
                              Icons.upload,
                              size: 32,
                              color: AppColors.current().text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}
