import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:unknown/common/route/app_routes.dart';

import 'main_state.dart';

class MainLogic extends GetxController {
  final MainState state = MainState();
  late PageController pageController;
  //用于判断左滑右滑
  late Offset _initialSwipeOffset;
  late Offset _finalSwipeOffset;

  void onPageChange(page) {
    state.currPage = page;
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: state.currPage);
  }

  onHorizontalDragStart(DragStartDetails details) {
    _initialSwipeOffset = details.globalPosition;
  }

  onHorizontalDragUpdate(DragUpdateDetails details) {
    _finalSwipeOffset = details.globalPosition;
  }

  onHorizontalDragEnd(DragEndDetails details) {
    if (_initialSwipeOffset != null) {
      final offsetDifference = _initialSwipeOffset.dx - _finalSwipeOffset.dx;
      final direction = offsetDifference > 0 ? print('left') : print('right');
    }
  }

  gotoPlayer() {
    Get.toNamed(AppRoutes.PLAYER);
  }

  gotoSearch() {
    Get.toNamed(AppRoutes.SEARCH);
  }

  void onBottomTap(int value) {
    state.currPage = value;
    pageController.jumpToPage(value);
  }
}
