import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/player/player_export.dart';
import '../../shared/utils/dynamic_style.dart';
import '../../core/app_colors.dart';
import '../../shared/utils/title_style.dart';
import '../../shared/widgets/repeat.dart';
import '../../shared/utils/slider_shape.dart';
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
      backgroundColor: colorBackground,
      appBar: null,
      body: Obx(() {
        final currentSong = playerStateController
            .songList[playerStateController.songIndex.value];
        return Stack(
          children: [
            Positioned.fill(
              child: QueryArtworkWidget(
                id: currentSong.id,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                quality: 100,
                artworkHeight: double.infinity,
                artworkWidth: double.infinity,
                nullArtworkWidget: Container(
                  color: colorBackground,
                ),
              ),
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
                          color: colorWhite,
                          size: 44,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorBackgroundDark,
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
                      child: QueryArtworkWidget(
                        id: currentSong.id,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        quality: 100,
                        artworkHeight: 300,
                        artworkWidth: 300,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: colorWhite,
                          size: 320,
                        ),
                      ),
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
                                currentSong.title.trim(),
                                style: titleStyle(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                currentSong.artist!.trim(),
                                style: dynamicStyle(16, colorWhiteGray,
                                    FontWeight.normal, FontStyle.normal),
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
                                      colorWhite,
                                      FontWeight.normal,
                                      FontStyle.normal,
                                    ),
                                  ),
                                  Text(
                                    playerStateController.songDuration.value,
                                    style: dynamicStyle(
                                      14,
                                      colorWhite,
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
                                  thumbColor: colorWhite,
                                  inactiveColor: colorGray,
                                  activeColor: colorWhite,
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
                                color: colorWhite,
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
                                color: colorWhite,
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
