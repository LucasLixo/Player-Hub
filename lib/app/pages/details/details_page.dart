import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/shared/widgets/center_text.dart';
import 'package:playerhub/app/shared/widgets/crud_sheet.dart';
import 'package:playerhub/app/shared/widgets/playlist_mode.dart';
import 'package:playerhub/app/shared/widgets/playlist_sheet.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: null,
      body: Obx(() {
        final currentSong = playerStateController.currentSong.value;

        if (currentSong == null) {
          return CenterText(title: 'cloud_error1'.tr);
        } else {
          final currentImage = playerStateController.currentImage.value;

          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: currentImage != null
                    ? Image.file(
                        File(currentImage),
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink(),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        leading: InkWell(
                          onTap: () => Get.back(),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                        actions: [
                          InkWell(
                            onTap: () => Get.toNamed(AppRoutes.equalizer),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: const Icon(
                              Icons.graphic_eq,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => crudSheet(context, currentSong),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: currentImage != null
                            ? Image.file(
                                File(currentImage),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppShared.getTitle(
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
                      const SizedBox(height: 4),
                      Text(
                        AppShared.getArtist(
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
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            playerStateController.songPosition.value,
                            style: dynamicStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          Text(
                            playerStateController.songDuration.value,
                            style: dynamicStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Slider(
                        thumbColor: Colors.white,
                        inactiveColor: Colors.white54,
                        activeColor: Colors.white,
                        min: 0.0,
                        max: playerStateController.songDurationD.value
                            .toDouble(),
                        value: playerStateController.songPositionD.value
                            .toDouble(),
                        onChanged: (newValue) {
                          playerController.chargeDurationInSeconds(
                            newValue.toInt(),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const PlaylistMode(),
                          InkWell(
                            onTap: () {
                              playerController.previousSong();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              playerController.togglePlayPause();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: _controller,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              playerController.nextSong();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: const Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const PlaylistSheet(),
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
