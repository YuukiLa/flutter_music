import 'package:get/get.dart';

import 'song_list_state.dart';

class SongListLogic extends GetxController {
  final SongListState state = SongListState();


  @override
  void onInit() {
    super.onInit();
    state.title.value = Get.arguments["title"];
    state.image.value = Get.arguments["image"];

  }

  onScroll(offset) {
    double alpha = offset / 100;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    print(alpha);
    state.appBarAlpha.value = alpha;
  }
}
