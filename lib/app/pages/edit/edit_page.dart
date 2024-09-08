import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:on_audio_query/on_audio_query.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/utils/my_toastification.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:playerhub/app/core/controllers/player.dart';

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
  final FocusNode _focusNodeTitle = FocusNode();
  final FocusNode _focusNodeArtist = FocusNode();

  RxBool isConect = false.obs;

  final playerStateController = Get.find<PlayerStateController>();

  @override
  void initState() {
    super.initState();
    // checkConnectivity();
    _textControllerTitle = TextEditingController(
      text: AppShared.getTitle(
        widget.song.id,
        widget.song.title,
      ),
    );
    _textControllerArtist = TextEditingController(
      text: AppShared.getArtist(
        widget.song.id,
        widget.song.artist!,
      ),
    );
  }

  @override
  void dispose() {
    _textControllerTitle.dispose();
    _textControllerArtist.dispose();
    super.dispose();
  }

  // Future<void> checkConnectivity() async {
  //   final connectivityResult = await Connectivity().checkConnectivity();
  //   for (var result in connectivityResult) {
  //     if (result == ConnectivityResult.wifi) {
  //       isConect.value = true;
  //       break;
  //     }
  //   }
  // }

  Future<void> saveInfo() async {
    await AppShared.setTitle(widget.song.id, _textControllerTitle.text);
    await AppShared.setArtist(widget.song.id, _textControllerArtist.text);
    _focusNodeTitle.unfocus();
    _focusNodeArtist.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
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
          AppShared.getTitle(widget.song.id, widget.song.title),
          style: dynamicStyle(
            fontSize: 18,
            fontColor: AppColors.text,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          InkWell(
            onTap: () {
              saveInfo();
              myToastification(
                context: context,
                title:
                    "${'edit_save'.tr}: ${AppShared.getTitle(widget.song.id, widget.song.title)}",
                icon: Icons.save,
              );
            },
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
                focusNode: _focusNodeTitle,
                style: dynamicStyle(
                  fontSize: 18,
                  fontColor: AppColors.text,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
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
                focusNode: _focusNodeArtist,
                style: dynamicStyle(
                  fontSize: 18,
                  fontColor: AppColors.text,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
                cursorColor: AppColors.text,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.text),
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 12,
            // ),
            // ListTile(
            //   title: Text(
            //     'edit_image'.tr,
            //     style: titleStyle(),
            //   ),
            //   trailing: InkWell(
            //     onTap: () {},
            //     splashColor: Colors.transparent,
            //     highlightColor: Colors.transparent,
            //     child: Icon(
            //       Icons.folder,
            //       color: AppColors.text,
            //       size: 26,
            //     ),
            //   ),
            //   subtitle: Center(
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(18),
            //       child: Obx(
            //         () {
            //           final currentSong = playerStateController
            //               .songList[playerStateController.songIndex.value];
            //           final imagePath =
            //               playerStateController.imageCache[currentSong.id];
            //
            //           return imagePath != null
            //               ? Image.file(
            //                   File(imagePath),
            //                   fit: BoxFit.cover,
            //                   width: 150.0,
            //                   height: 150.0,
            //                 )
            //               : const SizedBox(
            //                   width: 150.0,
            //                   height: 150.0,
            //                 );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
