import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/provider/netease.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/page/play_list/play_list_index.dart';

import '../../common/model/playlist_filter.dart';

class PlayListLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final PlayListState state = PlayListState();

  late final List<Tab> tabs;
  late final TabController tabController;
  late final RefreshController refreshController;
  final PlaylistFilter filter = Netease.playlistFilter();

  showPlaylist(bool isRefresh) async {
    var result =
        await MediaController.to.showPlaylistArray(Platform.NETEASE, state.currPage.value*35, "流行");
    if(isRefresh) {
      state.playlist.clear();
    }
    state.playlist.addAll(result!);
  }

  @override
  Future<void> onInit() async {
    EasyLoading.showProgress(0.3, status: '加载中...',maskType: EasyLoadingMaskType.black);
    tabs = [
      const Tab(text: "网易云"),
      const Tab(text: "qq音乐"),
    ];
    tabController = TabController(length: tabs.length, vsync: this);
    refreshController = RefreshController();
    await showPlaylist(true);
    EasyLoading.dismiss();
  }

  void onPlaylistTap(int index) {
    print(index);
  }
  Future<void> onRefresh() async {
    state.currPage.value = 0;
    await showPlaylist(true);
    refreshController.refreshCompleted();
  }
  Future<void> onLoading() async {
    state.currPage.value++;
    await showPlaylist(false);
    refreshController.loadComplete();
  }

}
