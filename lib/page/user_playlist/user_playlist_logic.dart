import 'package:get/get.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/utils/dialog.dart';

import '../../common/route/app_routes.dart';
import 'user_playlist_state.dart';

class UserPlaylistLogic extends GetxController {
  final UserPlaylistState state = UserPlaylistState();

  late String platform;

  @override
  void onInit() {
    platform = Get.arguments["platform"];
    getUserPlaylist();
    super.onInit();
  }

  getUserPlaylist() async {
    DialogUtil.showLoading();
    var list = await MediaController.to.getUserPlaylist(platform);
    if (list != null) {
      state.playlists.addAll(list);
    }
    DialogUtil.dismiss();
  }

  gotoDetail(Playlist playlist) {
    Get.toNamed(AppRoutes.SONG_LIST,
        arguments: {"id": playlist.id, "platform": platform});
  }
}
