import 'package:get/get.dart';

import 'play_list_logic.dart';

class PlayListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayListLogic());
  }
}
