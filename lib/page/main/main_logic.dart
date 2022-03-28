import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();
  late PageController pageController;

  void onPageChange(page) {
    state.currPage=page;
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
    // TODO: implement onClose
    super.onClose();
  }

  void onBottomTap(int value) {
    state.currPage=value;
    pageController.jumpToPage(value);
  }
}
