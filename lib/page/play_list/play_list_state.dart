import 'package:get/get.dart';
import 'package:unknown/common/model/playlist.dart';

import '../../common/model/playlist_filter.dart';

class PlayListState {
  var currTab = 0.obs;
  var playlist = [RxList<Playlist>(),RxList<Playlist>()];
  var filter= RxList<PlaylistFilter>();
  var currPage = [0,0].obs;
  var currFilter = [0,0].obs;
}
