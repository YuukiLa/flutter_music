import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          Center(child: Text("1"),),
          Center(child: Text("2"),)
        ],
        controller: controller.tabController,
      ),
    );
  }
}
