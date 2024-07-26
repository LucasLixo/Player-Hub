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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(52),
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
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: colorWhite,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.data.displayName,
                      style: styleText(
                        fontFamily: bold,
                        fontSize: 24,
                        color: colorBackground,
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
                        color: colorBackground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            playerController.position.value,
                            style: styleText(color: colorBackgroundDark),
                          ),
                          Expanded(
                            child: Slider(
                              thumbColor: colorSlider,
                              inactiveColor: colorBackground,
                              activeColor: colorSlider,
                              min: const Duration(seconds: 0).inSeconds.toDouble(),
                              max: playerController.max.value,
                              value: playerController.value.value,
                              onChanged: (newValue) {
                                playerController.chargeDurationToSeconds(newValue.toInt());
                                newValue = newValue;
                              },
                            ),
                          ),
                          Text(
                            playerController.duration.value,
                            style: styleText(color: colorBackgroundDark),
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
                            color: colorBackgroundDark,
                          ),
                        ),
                        Obx(
                          () => CircleAvatar(
                            radius: 35,
                            backgroundColor: colorBackgroundDark,
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
                            color: colorBackgroundDark,
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
    );
  }
}
