
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/provider/netease.dart';

class MediaController extends GetxController {

  static MediaController get to => Get.find();

  String queryStringify(Map<String,String> params) {
    var arr = [];
    params.forEach((key, value) => arr.add("$key=$value"));
    return arr.join("&");
  }

  void showPlaylistArray(Platform source,int offset,String filterID) {
    var url = "/show_playlist?${queryStringify({ "offset": offset.toString(), "filter_id": filterID })}";
    Netease.showPlaylist(url);
  }



}