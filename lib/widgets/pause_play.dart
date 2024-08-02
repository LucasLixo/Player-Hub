import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/controllers/player_export.dart';

class AnimatedPausePlay extends StatefulWidget {
  const AnimatedPausePlay({super.key});

  @override
  State<AnimatedPausePlay> createState() => _AnimatedPausePlayState();
}

class _AnimatedPausePlayState extends State<AnimatedPausePlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final playerController = Get.find<PlayerController>();
  final playerStateController = Get.find<PlayerStateController>();
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    playerStateController.isPlaying.listen((isPlaying) {
      if (!isDisposed) {
        if (isPlaying) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    isDisposed = true;
    _controller.dispose();
    super.dispose();
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
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.play_pause,
        progress: _controller,
      ),
      onPressed: _togglePlayPause,
      color: Colors.white,
    );
  }
}
