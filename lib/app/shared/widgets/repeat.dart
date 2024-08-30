import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:playerhub/app/core/controllers/player.dart';

class Repeat extends StatefulWidget {
  const Repeat({super.key});

  @override
  State<Repeat> createState() => _RepeatState();
}

class _RepeatState extends State<Repeat> {
  final List<IconData> icons = [Icons.repeat, Icons.repeat_one];
  int currentIndex = 0;

  final playerController = Get.put(PlayerController());
  final playerStateController = Get.put(PlayerStateController());

  @override
  void initState() {
    super.initState();
    setCurrentIcon();
    playerStateController.isLooping.listen((_) => setCurrentIcon());
  }

  void setCurrentIcon() {
    if (!mounted) return;

    if (playerStateController.isLooping.value) {
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

    await playerController.toggleLooping();
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
        icons[currentIndex],
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
