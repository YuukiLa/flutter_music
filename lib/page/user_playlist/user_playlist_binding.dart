import 'package:get/get.dart';

import 'user_playlist_logic.dart';

class UserPlaylistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserPlaylistLogic());
  }
}
