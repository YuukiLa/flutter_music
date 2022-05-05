import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/route/app_routes.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/utils/dialog.dart';
import 'package:unknown/page/play_list/play_list_index.dart';

class PlayListLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final PlayListState state = PlayListState();
  final List<String> platforms = [Platform.Netease, Platform.QQ];
  late final List<Tab> tabs;
  late final TabController tabController;
  late final Map<String, RefreshController> refreshControllerMap;
  late final RefreshController refreshController;

  showPlaylist(bool isRefresh) async {
    int currTab = state.currTab.value;
    if (isRefresh) {
      state.playlist[currTab].clear();
      state.currPage[currTab] = 0;
    }
    DialogUtil.showLoading();
    var result = await MediaController.to.showPlaylistArray(
        platforms[currTab],
        state.currPage[currTab] * 35,
        state.filter[currTab].recommend[state.currFilter[currTab]].id);
    // print(result);
    if (isRefresh) {
      state.playlist[currTab].clear();
    }
    state.playlist[currTab].addAll(result!);
    DialogUtil.dismiss();
  }

  @override
  Future<void> onInit() async {
    DialogUtil.showLoading();
    tabs = [
      const Tab(text: "网易云"),
      const Tab(text: "qq音乐"),
    ];
    tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(onTabChange);

    refreshControllerMap = {
      Platform.Netease: RefreshController(),
      Platform.QQ: RefreshController()
    };
    // refreshController = RefreshController();
    state.filter.addAll([
      await MediaController.to.getFilter(Platform.Netease),
      await MediaController.to.getFilter(Platform.QQ)
    ]);
    await showPlaylist(true);
  }

  void onPlaylistTap(int index) {
    // Netease.weapi("text");
    // Netease.getPlaylist("/playlist?list_id=${state.playlist[index].id}");
    // print(index);
    var playlist = state.playlist[state.currTab.value][index];
    Get.toNamed(AppRoutes.SONG_LIST,
        arguments: {"id": playlist.id, "platform": playlist.source});
  }

  onTabChange() async {
    state.currTab.value = tabController.index;
    if (state.playlist[tabController.index].isEmpty) {
      await showPlaylist(true);
    }
  }

  Future<void> onRefresh() async {
    state.currPage[state.currTab.value] = 0;
    await showPlaylist(true);
    refreshControllerMap[platforms[state.currTab.value]]?.refreshCompleted();
  }

  Future<void> onLoading() async {
    state.currPage[state.currTab.value]++;
    await showPlaylist(false);
    refreshControllerMap[platforms[state.currTab.value]]?.loadComplete();
  }

  onTagChange(int itemIndex) {
    state.currFilter[state.currTab.value] = itemIndex;
    if (itemIndex != 1) {
      showPlaylist(true);
    }
  }
}
