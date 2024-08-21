import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../shared/utils/functions/get_artist.dart';
import '../../shared/utils/title_style.dart';
import '../../shared/utils/functions/get_image.dart';

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

  Future<String> getImageForSong(int songId) async {
    return await getImage(id: songId);
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
              size: 32,
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
              trailing: FutureBuilder<String>(
                future: getImageForSong(widget.song.id),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasError) {
                    return const SizedBox.shrink();
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(snapshot.data!),
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
