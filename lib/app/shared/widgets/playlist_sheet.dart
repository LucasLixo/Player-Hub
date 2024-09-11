import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/utils/subtitle_style.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';

class PlaylistSheet extends StatefulWidget {
  const PlaylistSheet({super.key, required BuildContext context});

  @override
  State<PlaylistSheet> createState() => _PlaylistSheetState();
}

class _PlaylistSheetState extends State<PlaylistSheet> {
  final playerStateController = Get.find<PlayerStateController>();
  final playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.background,
          builder: (BuildContext context) {
            return Obx(
              () {
                final songList = playerStateController.songList;
                final songIndex = playerStateController.songIndex.value;

                if (songList.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: songList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final song = songList[index];

                      return ListTile(
                        tileColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 2.0),
                        title: Text(
                          AppShared.getTitle(song.id, song.title),
                          style: titleStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          AppShared.getArtist(song.id, song.artist!),
                          style: subtitleStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: songIndex == index
                            ? Icon(
                                Icons.music_note,
                                color: AppColors.text,
                                size: 32,
                              )
                            : const SizedBox.shrink(),
                        leading: FutureBuilder<Uint8List>(
                          future: AppShared.getImageArray(
                            id: song.id,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                width: 50.0,
                                height: 50.0,
                              );
                            } else if (snapshot.hasError || !snapshot.hasData) {
                              return const SizedBox(
                                width: 50.0,
                                height: 50.0,
                              );
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          playerController.playSong(index);
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: const Icon(
        Icons.queue_music,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
