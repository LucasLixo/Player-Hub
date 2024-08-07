import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './inc/list_music.dart';
import './inc/list_folder.dart';
import '../routes/app_routes.dart';
import '../shared/utils/dynamic_style.dart';
import '../core/app_colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: colorBackgroundDark,
        appBar: AppBar(
          backgroundColor: colorBackgroundDark,
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.search);
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
          title: Text(
            'Player Hub',
            style: dynamicStyle(
              18,
              colorWhite,
              FontWeight.normal,
              FontStyle.normal,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: colorSlider,
            indicatorWeight: 4,
            labelColor: colorSlider,
            unselectedLabelColor: colorWhiteGray,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.music_note),
              ),
              Tab(
                icon: Icon(Icons.folder),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[ListMusicView(), ListFolderView()],
        ),
      ),
    );
  }
}
