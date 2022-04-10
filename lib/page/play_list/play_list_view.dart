import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/page/play_list/widgets/playlist.dart';

import 'play_list_logic.dart';

class PlayListPage extends GetView<PlayListLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        isScrollable: true,
        tabs: controller.tabs,
        controller: controller.tabController,
      ),
      body: TabBarView(
        children: [
          PlaylistWidget(platform: Platform.Netease,index:0),
          PlaylistWidget(platform: Platform.QQ,index:1),
        ],
        controller: controller.tabController,

      ),
    );
  }
}
