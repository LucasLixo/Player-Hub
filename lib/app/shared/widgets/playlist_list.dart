import 'dart:io';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:flutter/src/material/text_button.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter/src/material/animated_icons.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:flutter/src/material/ink_well.dart';
import 'package:flutter/src/material/dialog.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter/src/widgets/scroll_view.dart';
import 'package:flutter/src/widgets/icon.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:flutter/src/widgets/image.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_playlist.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/widgets/center_text.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/routes/app_routes.dart';

class PlaylistList extends StatefulWidget {
  const PlaylistList({super.key});

  @override
  State<PlaylistList> createState() => _PlaylistListState();
}

class _PlaylistListState extends State<PlaylistList>
    with TickerProviderStateMixin {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      AppPlaylist.playlistLocal.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    playerController.audioPlayer.playerStateStream.listen((state) {
      for (int i = 0; i < AppPlaylist.playlistLocal.length; i++) {
        final playlist = AppPlaylist.playlistLocal[i];

        if (state.playing && playerStateController.songList == playlist.songs) {
          _controllers[i].forward();
        } else {
          _controllers[i].reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<String?> _showDialogPlaylistDelete(
      BuildContext context, int index, String title) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'playlist2'.tr,
                style: titleStyle(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'crud_sheet_dialog_1'.tr,
                      style: dynamicStyle(
                        16,
                        AppColors.primary,
                        FontWeight.w600,
                        FontStyle.normal,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      AppPlaylist.removePlaylist(title);
                      _controllers.removeAt(index).dispose();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'crud_sheet_dialog_2'.tr,
                      style: dynamicStyle(
                        16,
                        AppColors.primary,
                        FontWeight.w600,
                        FontStyle.normal,
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppPlaylist.playlistLocal.isEmpty
          ? CenterText(title: 'home_not_tab3'.tr)
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1,
                ),
                itemCount: AppPlaylist.playlistLocal.length,
                itemBuilder: (context, index) {
                  final playlist = AppPlaylist.playlistLocal[index];
                  final imagePath =
                      playerStateController.imageCache[playlist.songs[0].id];
                  final controller = _controllers[index];

                  return InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.playlist, arguments: {
                        'title': playlist.title,
                        'songs': playlist.songs,
                      });
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imagePath != null
                                ? Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          left: 5,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  playlist.title,
                                  style: dynamicStyle(
                                    18,
                                    Colors.white,
                                    FontWeight.normal,
                                    FontStyle.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () {
                                  _showDialogPlaylistDelete(
                                      context, index, playlist.title);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: const Icon(
                                  Icons.delete,
                                  size: 36,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          left: 5,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  playlist.songs[0].title,
                                  style: dynamicStyle(
                                    18,
                                    Colors.white,
                                    FontWeight.normal,
                                    FontStyle.normal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () async {
                                  if (playerStateController.songList !=
                                      playlist.songs) {
                                    playerController.songLoad(
                                      playlist.songs,
                                      0,
                                    );
                                  } else {
                                    if (playerStateController.isPlaying.value) {
                                      await playerController.pauseSong();
                                    } else {
                                      await playerController.playSong(
                                          playerStateController
                                              .songIndex.value);
                                    }
                                  }
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: controller,
                                  size: 36,
                                  color: AppColors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
