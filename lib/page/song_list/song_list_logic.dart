import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/utils/dialog.dart';

import '../../common/provider/netease.dart';
import 'song_list_state.dart';

class SongListLogic extends GetxController {
  final SongListState state = SongListState();
  late dynamic info;
  late String platform;


  getSongList() async{
    Dialog.showLoading();
    var res = await MediaController.to.getPlaylistSongs(platform,"/playlist?list_id=${state.id.value}");
    info = res["info"];
    state.title.value = info["title"];
    state.image.value = info["cover_img_url"];
    state.songs.addAll(res["tracks"]);
    Dialog.dismiss();
    print(res["tracks"]);
    print(state.songs.length);
  }

  @override
  void onInit() {
    super.onInit();
    state.id.value = Get.arguments["id"];
    platform = Get.arguments["platform"];
    getSongList();
  }

  onScroll(offset) {
    double alpha = offset / 100;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    state.appBarAlpha.value = alpha;
  }

  onSongClick(int index) {
    MediaController.to.getSongUrl(platform,state.songs[index].id);
    print(index);
  }
}
