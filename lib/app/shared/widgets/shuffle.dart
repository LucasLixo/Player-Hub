import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/controllers/player.dart';
import 'package:playerhub/app/core/app_colors.dart';

class Shuffle extends StatefulWidget {
  const Shuffle({super.key});

  @override
  State<Shuffle> createState() => _ShuffleState();
}

class _ShuffleState extends State<Shuffle> {
  final List<Color> colors = [Colors.white, AppColors.primary];
  int currentIndex = 0;

  final playerController = Get.put(PlayerController());
  final playerStateController = Get.put(PlayerStateController());

  @override
  void initState() {
    super.initState();
    setCurrentIcon();
    playerStateController.isShuffle.listen((_) => setCurrentIcon());
  }

  void setCurrentIcon() {
    if (!mounted) return;

    if (playerStateController.isShuffle.value) {
      setState(() {
        currentIndex = colors.indexOf(AppColors.primary);
      });
    } else {
      setState(() {
        currentIndex = colors.indexOf(Colors.white);
      });
    }
  }

  Future<void> onIconPressed() async {
    if (!mounted) return;

    setState(() {
      currentIndex = (currentIndex + 1) % colors.length;
    });

    await playerController.toggleShufflePlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onIconPressed();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Icon(
        Icons.shuffle,
        size: 30,
        color: colors[currentIndex],
      ),
    );
  }
}
