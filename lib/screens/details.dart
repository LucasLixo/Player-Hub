import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/controllers/player_export.dart';
import 'package:player/utils/colors.dart';
import 'package:player/utils/text_style.dart';
import 'package:player/widgets/pause_play.dart';
import 'package:player/widgets/repeat_shuffle.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();
    var playerStateController = Get.find<PlayerStateController>();

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
                      InkWell(
                        onTap: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: const Icon(
                          Icons.more_vert,
                          color: colorWhite,
                          size: 32,
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
                      onPanUpdate: (details) {
                        if (details.delta.dx > 1) {
                          playerController.previousSong();
                        } else if (details.delta.dx < -1) {
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
                                style: textStyle(
                                  fontFamily: bold,
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                currentSong.artist!.trim(),
                                style: textStyle(
                                  fontFamily: regular,
                                  fontSize: 16,
                                  color: colorWhiteGray,
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
                                    style: textStyle(fontSize: 14),
                                  ),
                                  Text(
                                    playerStateController.songDuration.value,
                                    style: textStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Slider(
                                thumbColor: colorWhite,
                                inactiveColor: colorGray,
                                activeColor: colorWhite,
                                min: 0.0,
                                max: playerStateController.songDurationD.value
                                    .toDouble(),
                                value: playerStateController.songPositionD.value
                                    .toDouble(),
                                onChanged: (newValue) {
                                  playerController.chargeDurationToSeconds(
                                    newValue.toInt(),
                                  );
                                },
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
                            const RepeatShuffle(),
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
                                child: const AnimatedPausePlay(),
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
