import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:unknown/common/service/player_service.dart';

import 'player_state.dart';

class PlayerLogic extends GetxController with GetTickerProviderStateMixin {
  final PlayerState state = PlayerState();

  late AnimationController animationController;

  @override
  void onInit() {
    state.currsong = PlayerService.instance.audioHandler.currPlaying;
    animationController = AnimationController(
        duration: Duration(seconds: 20), vsync: this);
    animationController.addStatusListener((status) {
      // print(status);
      if (status == AnimationStatus.completed) {
        // 如果转完一圈过后继续转
        animationController.reset();
        animationController.forward();
      }
    });
    super.onInit();
  }

  changeSwitchIndex() {
    state.switchIndex.value = state.switchIndex.value==0? 1:0;
  }

}
