import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class TestLogic extends GetxController {
  final TestState state = TestState();

  void increase() {
    state.count++;
    Get.changeTheme(Get.isDarkMode? ThemeData.light():ThemeData.dark());
    update();
  }
}
