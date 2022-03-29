import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/page/play_list/play_list_index.dart';


class PlayListLogic extends GetxController with SingleGetTickerProviderMixin{
  final PlayListState state = PlayListState();

  late final List<Tab> tabs;
  late final TabController tabController;

  showPlaylist() async {
    MediaController.to.showPlaylistArray(Platform.NETEASE, 1, "流行");
  }

  @override
  void onInit() {
    tabs = [
      const Tab(text: "网易云"),
      const Tab(text: "qq音乐"),
    ];
    tabController = TabController(length: tabs.length, vsync: this);
    showPlaylist();
  }
}
