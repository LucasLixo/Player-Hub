import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/app_colors.dart';
import 'package:playerhub/app/core/app_shared.dart';
import 'package:playerhub/app/routes/app_routes.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/shared/utils/title_style.dart';

class Shortcut extends StatefulWidget {
  const Shortcut({super.key});

  @override
  State<Shortcut> createState() => _ShortcutState();
}

class _ShortcutState extends State<Shortcut>
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
    ever(playerStateController.isPlaying, (isPlaying) {
      if (isPlaying) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final currentSong = playerStateController.currentSong.value;
        if (playerStateController.songList.isEmpty || currentSong == null) {
          return const SizedBox.shrink();
        } else {
          final currentImage = playerStateController.currentImage.value;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              tileColor: AppColors.surface,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(55),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              title: Text(
                AppShared.getTitle(
                  currentSong.id,
                  currentSong.title,
                ),
                style: titleStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: ClipOval(
                child: currentImage != null
                    ? Image.file(
                        File(currentImage),
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: 50.0,
                      )
                    : const SizedBox(
                        width: 50.0,
                        height: 50.0,
                      ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      playerController.previousSong();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(
                      Icons.skip_previous_rounded,
                      size: 32,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      playerController.togglePlayPause();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Obx(() {
                      if (playerStateController.isPlaying.value) {
                        _controller.forward();
                      } else {
                        _controller.reverse();
                      }
                      return AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: _controller,
                        size: 32,
                        color: Colors.white,
                      );
                    }),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      playerController.nextSong();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(
                      Icons.skip_next_rounded,
                      size: 32,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
              onTap: () {
                Get.toNamed(AppRoutes.details);
              },
            ),
          );
        }
      },
    );
  }
}
