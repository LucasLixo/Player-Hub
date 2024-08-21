import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

import '../../core/controllers/player.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../shared/widgets/repeat.dart';
import '../../shared/utils/slider_shape.dart';
import '../../routes/app_routes.dart';
import '../../shared/meta/get_artist.dart';
import '../../shared/widgets/shuffle.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();
  late AnimationController _controller;

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

  Future<void> _togglePlayPause() async {
    if (playerStateController.isPlaying.value) {
      await playerController.pauseSong();
    } else {
      await playerController.playSong(playerStateController.songIndex.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: null,
      body: Obx(() {
        final currentSong = playerStateController
            .songList[playerStateController.songIndex.value];
        final imagePath = playerStateController.imageCache[currentSong.id];
        
        return Stack(
          children: [
            Positioned.fill(
              child: imagePath != null
                ? Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.edit, arguments: {
                            'song': currentSong,
                          });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.80,
                    width: MediaQuery.of(context).size.width * 0.80,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.background,
                    ),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onPanEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          playerController.previousSong();
                        } else if (details.velocity.pixelsPerSecond.dx < 0) {
                          playerController.nextSong();
                        }
                      },
                      child: imagePath != null
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: MediaQuery.of(context).size.width * 0.80,
                          )
                        : const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                currentSong.title,
                                style: dynamicStyle(
                                  16,
                                  Colors.white,
                                  FontWeight.w600,
                                  FontStyle.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                getArtist(artist: currentSong.artist!),
                                style: dynamicStyle(
                                  16,
                                  Colors.white60,
                                  FontWeight.normal,
                                  FontStyle.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    playerStateController.songPosition.value,
                                    style: dynamicStyle(
                                      14,
                                      Colors.white,
                                      FontWeight.normal,
                                      FontStyle.normal,
                                    ),
                                  ),
                                  Text(
                                    playerStateController.songDuration.value,
                                    style: dynamicStyle(
                                      14,
                                      Colors.white,
                                      FontWeight.normal,
                                      FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              SliderTheme(
                                data: const SliderThemeData(
                                  trackShape: CustomSliderTrackShape(),
                                ),
                                child: Slider(
                                  thumbColor: Colors.white,
                                  inactiveColor: Colors.white54,
                                  activeColor: Colors.white,
                                  min: 0.0,
                                  max: playerStateController.songDurationD.value
                                      .toDouble(),
                                  value: playerStateController
                                      .songPositionD.value
                                      .toDouble(),
                                  onChanged: (newValue) {
                                    playerController.chargeDurationToSeconds(
                                      newValue.toInt(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Repeat(),
                            IconButton(
                              onPressed: playerController.previousSong,
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                  icon: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: _controller,
                                  ),
                                  onPressed: _togglePlayPause,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: playerController.nextSong,
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const Shuffle(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
