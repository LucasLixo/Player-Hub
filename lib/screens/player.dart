import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/components/pause_play.dart';
import 'package:player/components/style_text.dart';
import 'package:player/controllers/player_controller.dart';
import 'package:player/utils/const.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: null,
      body: Obx(() {
        final currentSong = playerController.songs[playerController.playerIndex.value];
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
              padding: screenPadding,
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
                          Icons.share,
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
                    child: QueryArtworkWidget(
                      id: currentSong.id,
                      type: ArtworkType.AUDIO,
                      artworkFit: BoxFit.cover,
                      quality: 100,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: colorWhite,
                        size: 320,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: Padding(
                      padding: screenPadding,
                      child: Column(
                        children: [
                          Text(
                            currentSong.displayName,
                            style: styleText(
                              fontFamily: bold,
                              fontSize: 22,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            currentSong.artist.toString(),
                            style: styleText(
                              fontFamily: regular,
                              fontSize: 18,
                              color: colorWhiteGray,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Obx(
                            () => Column(
                              children: [
                                Slider(
                                  thumbColor: colorWhite,
                                  inactiveColor: colorGray,
                                  activeColor: colorWhite,
                                  min: 0.0,
                                  max: playerController.max.value.toDouble(),
                                  value: playerController.value.value.toDouble(),
                                  onChanged: (newValue) {
                                    playerController.chargeDurationToSeconds(
                                      newValue.toInt(),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      playerController.position.value,
                                      style: styleText(
                                          fontFamily: bold, fontSize: 14),
                                    ),
                                    Text(
                                      playerController.duration.value,
                                      style: styleText(
                                          fontFamily: bold, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
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
