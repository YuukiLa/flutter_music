import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/page/play_list/widgets/playlist.dart';

import 'play_list_logic.dart';

class PlayListPage extends GetView<PlayListLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        tabs: controller.tabs,
        controller: controller.tabController,
      ),
      body: TabBarView(
        children: [
          PlaylistWidget(),
          Center(child: Text("2"),)
        ],
        controller: controller.tabController,
      ),
    );
  }
}
