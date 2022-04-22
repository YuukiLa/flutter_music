import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:unknown/common/route/app_routes.dart';

import 'main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();
  late PageController pageController;

  void onPageChange(page) {
    state.currPage = page;
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: state.currPage);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  gotoSearch() {
    Get.toNamed(AppRoutes.SEARCH);
  }

  void onBottomTap(int value) {
    state.currPage = value;
    pageController.jumpToPage(value);
  }
}
