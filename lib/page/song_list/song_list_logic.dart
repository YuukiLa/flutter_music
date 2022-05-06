import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/service/player_service.dart';
import 'package:unknown/common/utils/dialog.dart';

import '../../common/provider/netease.dart';
import 'song_list_state.dart';

class SongListLogic extends GetxController {
  final SongListState state = SongListState();
  late dynamic info;
  late String platform;
  late bool isRecommand;

  getSongList() async {
    DialogUtil.showLoading();
    var res = await MediaController.to
        .getPlaylistSongs(platform, "/playlist?list_id=${state.id.value}");
    info = res["info"];
    state.title.value = info["title"];
    state.image.value = info["cover_img_url"];
    state.songs.addAll(res["tracks"]);
    DialogUtil.dismiss();
  }

  getRecommand() async {
    DialogUtil.showLoading();
    var res = await MediaController.to.getRecommand(platform);
    state.title.value = "每日推荐";
    state.image.value = "https://s1.ax1x.com/2022/05/06/Ouajdf.jpg";
    state.songs.addAll(res!);
    DialogUtil.dismiss();
  }

  @override
  void onInit() {
    isRecommand = Get.arguments["recommand"] ?? false;
    state.id.value = Get.arguments["id"] ?? "";
    platform = Get.arguments["platform"];
    if (isRecommand) {
      getRecommand();
    } else {
      getSongList();
    }
    super.onInit();
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

  //播放全部
  playAll() {
    PlayerService.instance.playSongs(state.songs);
  }

  onSongClick(int index) async {
    //TODO change to use playerservice
    await MediaController.to.play(state.songs[index]);
    print(index);
  }
}
