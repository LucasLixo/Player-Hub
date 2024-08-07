import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/player/player_export.dart';
import '../../shared/utils/title_style.dart';
import '../../shared/widgets/music_list.dart';
import '../../shared/widgets/shortcut.dart';

class ListMusicView extends StatefulWidget {
  const ListMusicView({super.key});

  @override
  _ListMusicViewState createState() => _ListMusicViewState();
}

class _ListMusicViewState extends State<ListMusicView> {
  @override
  Widget build(BuildContext context) {
    final playerController = Get.put(PlayerController());

    return FutureBuilder<List<SongModel>>(
      future: playerController.getSongs(),
      builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('Sem Músicas', style: titleStyle()),
          );
        } else {
          playerController.songAllLoad(snapshot.data!);

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: MusicList(songs: snapshot.data!),
              ),
              const Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Shortcut(),
              ),
            ],
          );
        }
      },
    );
  }
}
