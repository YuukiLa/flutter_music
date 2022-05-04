import 'package:get/get.dart';

import '../../common/model/song.dart';

class PlayerState {
  var currsong = Song.emptySong().obs;
  List<Song> list = <Song>[].obs;
  var listLen = 0.obs;
  var isPlaying = false.obs;
  var switchIndex = 0.obs;
  var showplanet = true.obs;
  var currPosition = 0.obs;
}
