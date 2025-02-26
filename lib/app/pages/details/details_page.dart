import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/enums/shared_attibutes.dart';
import 'package:player_hub/app/core/enums/theme_types.dart';
import 'package:player_hub/app/services/app_chrome.dart';
import 'package:player_hub/app/services/app_shared.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:player_hub/app/core/types/app_functions.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/shared/class/center_text.dart';
import 'package:player_hub/app/shared/more_vert/crud_music.dart';
import 'package:player_hub/app/shared/widgets/playlist_mode.dart';
import 'package:player_hub/app/shared/more_vert/detailts_sheet.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin, AppFunctions {
  late AnimationController _controller;

  final PlayerController playerController = Get.find<PlayerController>();
  final AppShared sharedController = Get.find<AppShared>();
  final AppChrome chromeController = Get.find<AppChrome>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    playerController.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    chromeController.loadTheme(isRebirth: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: null,
      body: Obx(() {
        final currentSong = playerController.currentSong.value;

        if (currentSong == null) {
          return CenterText(title: 'cloud_error1'.tr);
        } else {
          final Uint8List? currentImage = playerController.currentImage.value;

          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: currentImage != null
                    ? Image.memory(
                        currentImage,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink(),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        systemOverlayStyle: sharedController
                                .getShared<bool>(SharedAttributes.darkMode)
                            ? chromeController
                                .loadThemeByType(ThemeTypes.defaultDark)
                            : chromeController
                                .loadThemeByType(ThemeTypes.defaultLight),
                        foregroundColor: Colors.transparent,
                        leading: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () async {
                              await Get.toNamed(AppRoutes.equalizer);
                            },
                            child: const Icon(
                              Icons.graphic_eq,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await crudMusic(
                                song: currentSong,
                              );
                            },
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: currentImage != null
                            ? Image.memory(
                                currentImage,
                                fit: BoxFit.cover,
                                width: Get.width,
                                height: Get.width,
                              )
                            : SizedBox(
                                width: Get.width,
                                height: Get.width,
                              ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        sharedController.getTitle(
                          currentSong.id,
                          currentSong.title,
                        ),
                        style: dynamicStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        sharedController.getArtist(
                          currentSong.id,
                          currentSong.artist!,
                        ),
                        style: dynamicStyle(
                          color: Colors.white60,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            playerController.songPosition.value,
                            style: dynamicStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          Text(
                            playerController.songDuration.value,
                            style: dynamicStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Slider(
                        thumbColor: Colors.white,
                        inactiveColor: Colors.white54,
                        activeColor: Colors.white,
                        min: 0.0,
                        max: playerController.songDurationD.value,
                        value: playerController.songPositionD.value,
                        onChanged: (newValue) {
                          playerController.chargeDurationInSeconds(
                            newValue.toInt(),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          playlistMode(),
                          GestureDetector(
                            onTap: () async {
                              await playerController.previousSong();
                            },
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await playerController.togglePlayPause();
                            },
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: _controller,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await playerController.nextSong();
                            },
                            child: const Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          detailsSheet(),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
