import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/components/style_text.dart';
import 'package:player/controllers/player_controller.dart';
import 'package:player/utils/const.dart';

class Player extends StatefulWidget {
  final SongModel data;
  const Player({super.key, required this.data});

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
      body: Stack(
        children: [
          Positioned.fill(
            child: QueryArtworkWidget(
              id: widget.data.id,
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
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: const Icon(
                        Icons.arrow_back,
                        color: colorWhite,
                        size: 32,
                      ),
                    ),
                  ),
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
                    color: colorSlider,
                  ),
                  alignment: Alignment.center,
                  child: QueryArtworkWidget(
                    id: widget.data.id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    quality: 100,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    nullArtworkWidget: const Icon(
                      Icons.music_note,
                      color: colorWhite,
                      size: 64,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.data.displayName,
                        style: styleText(
                          fontFamily: bold,
                          fontSize: 24,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.data.artist.toString(),
                        style: styleText(
                          fontFamily: regular,
                          fontSize: 20,
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
                            SizedBox(
                              height: 60,
                              child: Slider(
                                thumbColor: colorWhite,
                                inactiveColor: colorBackground,
                                activeColor: colorWhite,
                                min: 0.0,
                                max: playerController.max.value.toDouble(),
                                value: playerController.value.value.toDouble(),
                                onChanged: (newValue) {
                                  playerController.chargeDurationToSeconds(
                                      newValue.toInt());
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  playerController.position.value,
                                  style: styleText(fontFamily: bold),
                                ),
                                Text(
                                  playerController.duration.value,
                                  style: styleText(fontFamily: bold),
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
                            onPressed: () {},
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: colorWhite,
                            ),
                          ),
                          Obx(
                            () => CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.transparent,
                              child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                  onPressed: () {
                                    if (playerController.isPLaying.value) {
                                      playerController.audioPlayer.pause();
                                      playerController.isPLaying.value = false;
                                    } else {
                                      playerController.audioPlayer.play();
                                      playerController.isPLaying.value = true;
                                    }
                                  },
                                  icon: playerController.isPLaying.value
                                      ? const Icon(
                                          Icons.pause_rounded,
                                          size: 24,
                                          color: colorWhite,
                                        )
                                      : const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 24,
                                          color: colorWhite,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
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
      ),
    );
  }
}
