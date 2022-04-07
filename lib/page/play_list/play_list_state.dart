import 'package:get/get.dart';
import 'package:unknown/common/model/playlist.dart';

import '../../common/model/playlist_filter.dart';

class PlayListState {
  var currTab = 0.obs;
  RxList<Playlist> playlist = <Playlist>[].obs;
  RxMap<String,PlaylistFilter> filter= RxMap<String,PlaylistFilter>();
  var currPage = 0.obs;
  var currFilter = 0.obs;
}
