import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:player_hub/app/core/static/app_colors.dart';
import 'package:player_hub/app/core/static/app_shared.dart';
import 'package:player_hub/app/routes/app_routes.dart';
import 'package:player_hub/app/core/controllers/player.dart';
import 'package:helper_hub/src/theme_widget.dart';

class Shortcut extends StatefulWidget {
  const Shortcut({super.key});

  @override
  State<Shortcut> createState() => _ShortcutState();
}

class _ShortcutState extends State<Shortcut>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final PlayerController playerController = Get.find<PlayerController>();

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
    return SafeArea(
      child: Obx(
        () {
          final currentSong = playerController.currentSong.value;
          if (playerController.songList.isEmpty) {
            return const Space(size: 0);
          }
          if (currentSong == null) {
            playerController
                .handleCurrentIndex(playerController.songIndex.value);
          }
          if (currentSong != null) {
            final currentImage = playerController.currentImage.value;

            return ListTile(
              tileColor: AppColors.current().surface,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10 + 4.0,
                vertical: 2.0,
              ),
              title: Text(
                AppShared.getTitle(
                  currentSong.id,
                  currentSong.title,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                playerController.songPosition.value,
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              leading: ClipOval(
                child: currentImage != null
                    ? Image.memory(
                        currentImage,
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
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      playerController.previousSong();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(
                      Icons.skip_previous_rounded,
                      size: 32,
                      color: AppColors.current().text,
                    ),
                  ),
                  const Space(size: 0),
                  InkWell(
                    onTap: () {
                      playerController.togglePlayPause();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _controller,
                      size: 32,
                      color: AppColors.current().text,
                    ),
                  ),
                  const Space(size: 0),
                  InkWell(
                    onTap: () {
                      playerController.nextSong();
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(
                      Icons.skip_next_rounded,
                      size: 32,
                      color: AppColors.current().text,
                    ),
                  ),
                  const Space(size: 0),
                ],
              ),
              onTap: () async {
                await Get.toNamed(AppRoutes.details);
              },
            );
          }

          return const Space(size: 0);
        },
      ),
    );
  }
}
