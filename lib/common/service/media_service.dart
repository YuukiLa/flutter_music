
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/provider/abstract_provider.dart';
import 'package:unknown/common/provider/netease.dart';
import 'package:unknown/common/provider/qq.dart';

class MediaController extends GetxController {

  static MediaController get to => Get.find();

  static Map<String,AbstractProvider> providers = {
    Platform.Netease: Netease(),
    Platform.QQ:QQ(),
  };

  String queryStringify(Map<String,String> params) {
    var arr = [];
    params.forEach((key, value) => arr.add("$key=$value"));
    return arr.join("&");
  }




  Future<List<Playlist>?> showPlaylistArray(String source,int offset,String filterID) async{
    var url = "/show_playlist?${queryStringify({ "offset": offset.toString(), "filter_id": filterID })}";
    return await providers[source]?.showPlaylist(url);
  }

  getPlaylistSongs(String source,String url) async{
    return await providers[source]?.getPlaylist(url);
  }

  getSongUrl(String source,String id) async{
    return await providers[source]?.getSongUrl(id);
  }

  getFilter(String source) async {
    return await providers[source]?.playlistFilter();
  }


}