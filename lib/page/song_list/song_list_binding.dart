import 'package:get/get.dart';

import 'song_list_logic.dart';

class SongListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SongListLogic());
  }
}
