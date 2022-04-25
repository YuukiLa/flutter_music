import 'package:get/get.dart';
import 'package:unknown/common/model/song.dart';

class SearchState {
  var keyword = "".obs;
  var currTab = 0.obs;
  var songs = [RxList<Song>(),RxList<Song>()];
  var currPage = [1,1].obs;
}
