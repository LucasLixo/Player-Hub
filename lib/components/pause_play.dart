import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/controllers/player_controller.dart';

class AnimatedPausePlay extends StatefulWidget {
  const AnimatedPausePlay({super.key});

  @override
  State<AnimatedPausePlay> createState() => _AnimatedPausePlayState();
}

class _AnimatedPausePlayState extends State<AnimatedPausePlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final playerController = Get.find<PlayerController>();
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    playerController.isPlaying.listen((isPlaying) {
      if (!isDisposed) {
        if (isPlaying) {
          _controller.reverse();
        } else {
          _controller.forward();
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

  void _togglePlayPause() {
    setState(() {
      if (playerController.isPlaying.value) {
        playerController.audioPlayer.pause();
        playerController.isPlaying.value = false;
      } else {
        playerController.audioPlayer.play();
        playerController.isPlaying.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.pause_play,
        progress: _controller,
      ),
      onPressed: _togglePlayPause,
      color: Colors.white,
    );
  }
}
