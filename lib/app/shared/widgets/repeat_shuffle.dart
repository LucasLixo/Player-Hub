import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/player/player_export.dart';
import '../../core/app_colors.dart';

class RepeatShuffle extends StatefulWidget {
  const RepeatShuffle({super.key});

  @override
  State<RepeatShuffle> createState() => _RepeatShuffleState();
}

class _RepeatShuffleState extends State<RepeatShuffle> {
  final List<IconData> icons = [Icons.repeat, Icons.repeat_one, Icons.shuffle];
  int currentIndex = 0;

  final playerController = Get.put(PlayerController());
  final playerStateController = Get.put(PlayerStateController());

  @override
  void initState() {
    super.initState();
    setCurrentIcon();
    playerStateController.isLooping.listen((_) => setCurrentIcon());
    playerStateController.isShuffle.listen((_) => setCurrentIcon());
  }

  void setCurrentIcon() {
    if (!mounted) return;

    if (playerStateController.isShuffle.value) {
      setState(() {
        currentIndex = icons.indexOf(Icons.shuffle);
      });
    } else if (playerStateController.isLooping.value) {
      setState(() {
        currentIndex = icons.indexOf(Icons.repeat_one);
      });
    } else {
      setState(() {
        currentIndex = icons.indexOf(Icons.repeat);
      });
    }
  }

  Future<void> onIconPressed() async {
    if (!mounted) return;

    setState(() {
      currentIndex = (currentIndex + 1) % icons.length;
    });

    switch (icons[currentIndex]) {
      case Icons.repeat:
        if (playerStateController.isShuffle.value) {
          await playerController.shufflePlaylistToggle();
        }
        break;
      case Icons.repeat_one:
        await playerController.toggleLooping();
        break;
      case Icons.shuffle:
        await playerController.toggleLooping();
        await playerController.shufflePlaylistToggle();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icons[currentIndex],
        size: 30,
        color: colorWhite,
      ),
      onPressed: onIconPressed,
    );
  }
}
