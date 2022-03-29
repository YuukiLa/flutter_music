
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/provider/netease.dart';

class MediaController extends GetxController {

  static MediaController get to => Get.find();

  String queryStringify(Map<String,String> params) {
    var arr = [];
    params.forEach((key, value) => arr.add("$key=$value"));
    return arr.join("&");
  }

  Future<List<Playlist>?> showPlaylistArray(Platform source,int offset,String filterID) async{
    var url = "/show_playlist?${queryStringify({ "offset": offset.toString(), "filter_id": filterID })}";
    return await Netease.showPlaylist(url);
  }



}