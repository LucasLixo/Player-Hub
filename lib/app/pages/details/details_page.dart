import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/utils/dynamic_style.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/shared/widgets/crud_sheet.dart';
import 'package:playerhub/app/shared/widgets/repeat.dart';
import 'package:playerhub/app/shared/utils/slider_shape.dart';
import 'package:playerhub/app/shared/widgets/shuffle.dart';

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
              padding: const EdgeInsets.all(12),
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
                          crudSheet(context, currentSong);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: imagePath != null
                        ? Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            width: 350,
                            height: 350,
                          )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          AppShared.getTitle(
                            currentSong.id,
                            currentSong.title,
                          ),
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
                          AppShared.getArtist(
                            currentSong.id,
                            currentSong.artist!,
                          ),
                          style: dynamicStyle(
                            16,
                            Colors.white60,
                            FontWeight.normal,
                            FontStyle.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  SliderTheme(
                    data: getSliderTheme(),
                    child: Slider(
                      thumbColor: Colors.white,
                      inactiveColor: Colors.white54,
                      activeColor: Colors.white,
                      min: 0.0,
                      max: playerStateController.songDurationD.value.toDouble(),
                      value:
                          playerStateController.songPositionD.value.toDouble(),
                      onChanged: (newValue) {
                        playerController.chargeDurationToSeconds(
                          newValue.toInt(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Repeat(),
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
                          _togglePlayPause();
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
                      const Shuffle(),
                    ],
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
