import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/common/service/player_service.dart';
import 'package:unknown/common/utils/dialog.dart';
import 'package:unknown/page/search/search_state.dart';

import '../../common/enums/platform.dart';
import '../../common/model/song.dart';
import '../../common/service/media_service.dart';

class SearchLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SearchState state = SearchState();
  final List<String> platforms = [Platform.Netease, Platform.QQ];
  late final List<Tab> tabs;
  late final TabController tabController;
  late final TextEditingController textEditingController;
  late final List<RefreshController> refreshControllers;

  @override
  // ignore: must_call_super
  Future<void> onInit() async {
    tabs = [
      const Tab(text: "网易云"),
      const Tab(text: "qq音乐"),
    ];
    tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(onTabChange);
    textEditingController = TextEditingController();
    refreshControllers = [RefreshController(), RefreshController()];
  }

  _searchSong(bool isRefresh) async {
    DialogUtil.showLoading();
    var result = await MediaController.to.searchSong(
        platforms[state.currTab.value],
        state.currPage[state.currTab.value],
        state.keyword.value);
    if (isRefresh) {
      for (var element in state.songs) {
        element.clear();
      }
    }
    state.songs[state.currTab.value].addAll(result!);
    DialogUtil.dismiss();
  }

  onTabChange() {
    state.currTab.value = tabController.index;
    if (state.keyword.value == "") {
      return;
    }
    if (state.songs[tabController.index].isEmpty) {
      _searchSong(false);
    }
  }

  void onTextChange(value) {
    state.keyword.value = value;
  }

  onCancel() {
    Get.back();
  }

  playSong(Song song) {
    PlayerService.instance.play(song);
  }

  onClear() {
    textEditingController.clear();
    state.keyword.value = "";
  }

  onSearch(String value) {
    if (value == "") {
      DialogUtil.toast("请输入要搜索的歌曲");
      return;
    }
    _searchSong(true);
  }

  onLoad() async {
    state.currPage[state.currTab.value]++;
    await _searchSong(false);
    refreshControllers[state.currTab.value].loadComplete();
  }
}
