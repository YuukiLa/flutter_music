import 'package:get/get.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/model/user.dart';

class AccountState {
  var qqUser = UserModel("", "2", "", "").obs;
  var neteaseUser = UserModel("", "3", "", "").obs;
  var playlistName = "".obs;
  var localPlaylist = <Playlist>[].obs;
}
