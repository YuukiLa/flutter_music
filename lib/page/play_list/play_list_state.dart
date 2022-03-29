import 'package:get/get.dart';
import 'package:unknown/common/model/playlist.dart';

class PlayListState {
  var currTab = 0.obs;
  RxList<Playlist> playlist = <Playlist>[].obs;
}
