import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/components/style_text.dart';
import 'package:player/controllers/player_controller.dart';
import 'package:player/screens/player.dart';
import 'package:player/utils/const.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playerController = Get.put(PlayerController());

    return FutureBuilder<List<SongModel>>(
      future: playerController.audioQuery.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: UriType.EXTERNAL,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('Sem Músicas', style: styleText()),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var song = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Obx(
                    () => ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: colorBackground,
                      title: Text(
                        song.title,
                        style: styleText(fontFamily: bold, fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song.artist ?? '',
                        style: styleText(fontFamily: regular, fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: QueryArtworkWidget(
                        id: song.id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: colorWhite,
                          size: 32,
                        ),
                      ),
                      trailing: playerController.playerIndex.value == index &&
                              playerController.isPLaying.value
                          ? const Icon(
                              Icons.play_arrow,
                              color: colorWhite,
                              size: 26,
                            )
                          : null,
                      onTap: () {
                        Get.to(
                          () => Player(data: song),
                          transition: Transition.downToUp,
                        );
                        playerController.playSong(song.uri, index);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
