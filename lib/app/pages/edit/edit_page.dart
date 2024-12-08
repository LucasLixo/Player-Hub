import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_hub/app/core/enums/theme_types.dart';
import 'package:player_hub/app/services/app_chrome.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/types/app_functions.dart';
import 'package:player_hub/app/core/static/app_manifest.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:helper_hub/src/theme_widget.dart';
import 'package:share_plus/share_plus.dart';

class EditPage extends StatelessWidget with AppFunctions {
  final PlayerController playerController = Get.find<PlayerController>();
  final AppShared sharedController = Get.find<AppShared>();
  final AppChrome chromeController = Get.find<AppChrome>();

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
      await sharedController.setTitle(song.id, textControllerTitle.text);
      await sharedController.setArtist(song.id, textControllerArtist.text);

      if (imagePicker.value != null) {
        await Get.toNamed(AppRoutes.splash, arguments: {
          'function': () async {
            await Future.wait([
              Future.delayed(const Duration(seconds: 1)),
              AppManifest.setImageFile(
                id: song.id,
                bytes: await imagePicker.value!.readAsBytes(),
              ),
            ]);
          },
        });
      }

      await showToast(
        "${'edit_save'.tr}: ${sharedController.getTitle(song.id, song.title)}",
      );
    } catch (e) {
      // print('Failed to save information.');
    }
  }

  Future<void> _pickerFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        imagePicker.value = File(result.files.single.path!);
      }
    } catch (e) {
      // print('Failed to pick file.');
    }
  }

  Future<void> _shareImage() async {
    final String? pathShared =
        imagePicker.value?.path ?? playerController.currentImagePath.value;

    if (pathShared != null) {
      await Share.shareXFiles(
        [XFile(pathShared, name: song.displayNameWOExt)],
        text: sharedController.getTitle(song.id, song.title),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    textControllerTitle.text = sharedController.getTitle(song.id, song.title);
    textControllerArtist.text =
        sharedController.getArtist(song.id, song.artist!);

    final String? imageFile = playerController.currentImagePath.value;

    return Scaffold(
      backgroundColor: AppColors.current().background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.current().background,
        systemOverlayStyle: chromeController.loadThemeByType(
          ThemeTypes.topOneBottomOne,
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
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
          /* GestureDetector(
            onTap: () async {
              final results = await editController.fetchMusics(
                sharedController.getArtist(song.id, song.artist!),
                sharedController.getTitle(song.id, song.title),
              );
            },
            child: Icon(
              Icons.language,
              color: AppColors.current().text,
              size: 32,
            ),
          ),
          const Space(), */
          GestureDetector(
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
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'edit_title'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: TextField(
                  cursorHeight: 28.0,
                  controller: textControllerTitle,
                  focusNode: null,
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
                ),
              ),
              ListTile(
                title: Text(
                  'edit_artist'.tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: TextField(
                  cursorHeight: 28.0,
                  controller: textControllerArtist,
                  focusNode: null,
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
                ),
              ),
              const Space(
                size: 12,
                orientation: Axis.vertical,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
                              'edit_share'.tr,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
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
                              'edit_replace'.tr,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
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
            ],
          ),
        ),
      ),
    );
  }
}
