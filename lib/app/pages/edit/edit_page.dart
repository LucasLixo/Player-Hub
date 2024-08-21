import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../shared/meta/get_artist.dart';
import '../../shared/utils/title_style.dart';
import '../../core/controllers/player.dart';

class EditPage extends StatefulWidget {
  final SongModel song;

  const EditPage({
    super.key,
    required this.song,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _textControllerTitle;
  late TextEditingController _textControllerArtist;

  RxBool isConect = false.obs;

  final playerStateController = Get.find<PlayerStateController>();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    _textControllerTitle = TextEditingController(text: widget.song.title);
    _textControllerArtist =
        TextEditingController(text: getArtist(artist: widget.song.artist!));
  }

  @override
  void dispose() {
    _textControllerTitle.dispose();
    _textControllerArtist.dispose();
    super.dispose();
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    for (var result in connectivityResult) {
      if (result == ConnectivityResult.wifi) {
        isConect.value = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text,
            size: 26,
          ),
        ),
        title: Text(
          widget.song.title,
          style: dynamicStyle(
            18,
            AppColors.text,
            FontWeight.normal,
            FontStyle.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          InkWell(
            onTap: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Icon(
              Icons.save,
              color: AppColors.text,
              size: 26,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'edit_title'.tr,
                style: titleStyle(),
              ),
              subtitle: TextField(
                controller: _textControllerTitle,
                style: dynamicStyle(
                  18,
                  AppColors.text,
                  FontWeight.normal,
                  FontStyle.normal,
                ),
                cursorColor: AppColors.text,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.text),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'edit_artist'.tr,
                style: titleStyle(),
              ),
              subtitle: TextField(
                controller: _textControllerArtist,
                style: dynamicStyle(
                  18,
                  AppColors.text,
                  FontWeight.normal,
                  FontStyle.normal,
                ),
                cursorColor: AppColors.text,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.text),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ListTile(
              title: Text(
                'edit_image'.tr,
                style: titleStyle(),
              ),
              trailing: Obx(
                () {
                  final currentSong = playerStateController
                      .songList[playerStateController.songIndex.value];
                  final imagePath =
                      playerStateController.imageCache[currentSong.id];

                  return imagePath != null
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
