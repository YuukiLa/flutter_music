
import 'dart:convert';

import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/provider/abstract_provider.dart';
import 'package:unknown/common/provider/netease.dart';
import 'package:unknown/common/provider/qq.dart';
import 'package:unknown/common/service/player_service.dart';
import 'package:unknown/common/service/storage.dart';

import '../model/song.dart';

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

  play(Song song) async {
    var finalSong = await getSongUrl(song);
    if(finalSong.url!="" && !finalSong.disabled) {
      PlayerService.instance.play(finalSong);
    }
  }
  playByID(String platform,String id) {

  }

  Future<List<Song>?> searchSong(String source,int currPage,String keyword) async{
    var result = await providers[source]?.search(keyword, currPage);
    print(jsonEncode(result));
    return result;
  }

  Future<List<Playlist>?> showPlaylistArray(String source,int offset,String filterID) async{
    var url = "/show_playlist?${queryStringify({ "offset": offset.toString(), "filter_id": filterID })}";
    return await providers[source]?.showPlaylist(url);
  }

  getPlaylistSongs(String source,String url) async{
    return await providers[source]?.getPlaylist(url);
  }

  Future<Song> getSongUrl(Song song) async{
    Song? dbSong = await StorageService.to.getSongById(song.id);
    if(dbSong!=null) {
      print("dbsong");
      return dbSong;
    }
    var url = await providers[song.source]?.getSongUrl(song.id);
    song.url = url;
    StorageService.to.saveSong(song);
    print("new song");
    return song;
  }

  getFilter(String source) async {
    return await providers[source]?.playlistFilter();
  }


}