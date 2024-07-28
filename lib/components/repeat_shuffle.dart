import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/utils/const.dart';
import 'package:player/controllers/player_controller.dart';

class RepeatShuffle extends StatefulWidget {
  const RepeatShuffle({super.key});

  @override
  State<RepeatShuffle> createState() => _RepeatShuffleState();
}

class _RepeatShuffleState extends State<RepeatShuffle> {
  final List<IconData> icons = [Icons.repeat, Icons.repeat_one, Icons.shuffle];
  int currentIndex = 0;

  final playerController = Get.put(PlayerController());

  @override
  void initState() {
    super.initState();
    setCurrentIcon();
    playerController.isLooping.listen((_) => setCurrentIcon());
    playerController.isShuffle.listen((_) => setCurrentIcon());
  }

  void setCurrentIcon() {
    if (!mounted) return;
    
    if (playerController.isShuffle.value && playerController.isLooping.value) {
      setState(() {
        currentIndex = icons.indexOf(Icons.shuffle);
      });
    } else if (playerController.isLooping.value) {
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
        await playerController.shufflePlaylistToggle();
        playerController.toggleLooping();
        break;
      case Icons.repeat_one:
        playerController.toggleLooping();
        break;
      case Icons.shuffle:
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
