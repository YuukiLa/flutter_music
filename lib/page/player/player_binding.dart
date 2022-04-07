import 'package:get/get.dart';

import 'player_logic.dart';

class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayerLogic());
  }
}
