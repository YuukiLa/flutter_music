import 'package:get/get.dart';
import 'package:unknown/page/play_list/play_list_index.dart';

import 'main_logic.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainLogic());
    Get.lazyPut(() => PlayListLogic());
  }
}
