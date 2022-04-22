import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unknown/page/search/search_state.dart';

class SearchLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SearchState state = SearchState();
  late final List<Tab> tabs;
  late final TabController tabController;
  late final TextEditingController textEditingController;

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
  }

  onTabChange() {}

  void onTextChange(value) {
    state.keyword.value = value;
  }

  onCancel() {
    Get.back();
  }

  onClear() {
    textEditingController.clear();
    state.keyword.value = "";
  }
}
