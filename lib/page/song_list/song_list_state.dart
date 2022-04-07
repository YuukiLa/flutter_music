import 'package:get/get.dart';

import '../../common/model/song.dart';

class SongListState {
  var appBarAlpha = 0.0.obs;
  var title = "".obs;
  var image = "".obs;

  var id = "".obs;

  var songs = <Song>[].obs;
}
