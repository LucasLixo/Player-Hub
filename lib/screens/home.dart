import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/screens/details.dart';
import 'package:player/screens/search.dart';
import 'package:player/utils/colors.dart';
import 'package:player/utils/text_style.dart';
import 'package:player/controllers/player_export.dart';
import 'package:player/widgets/shortcut.dart';

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
    final playerController = Get.put(PlayerController());

    return Scaffold(
      backgroundColor: colorBackgroundDark,
      appBar: AppBar(
        backgroundColor: colorBackgroundDark,
        actions: [
          InkWell(
            onTap: () {
              Get.to(
                () => const Search(),
                transition: Transition.rightToLeft,
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: const Icon(
              Icons.search,
              color: colorWhite,
              size: 32,
            ),
          ),
        ],
        title: Text('Player Hub', style: textStyle(fontSize: 24)),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: playerController.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: SongSortType.DATE_ADDED,
          uriType: UriType.EXTERNAL,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Sem Músicas', style: textStyle()),
            );
          } else {
            playerController.songAllLoad(snapshot.data!);

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var song = snapshot.data![index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: Colors.transparent,
                          title: Text(
                            song.title.trim(),
                            style: textStyle(fontFamily: bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            song.artist!.trim(),
                            style: textStyle(fontFamily: regular, fontSize: 16),
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
                          /* trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: colorWhite,
                                size: 28,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ), */
                        onTap: () {
                          playerController.playSong(index);
                          Get.to(
                            () => const Details(),
                            transition: Transition.downToUp,
                          );
                        },
                        ),
                      );
                    },
                  ),
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
      ),
    );
  }
}
