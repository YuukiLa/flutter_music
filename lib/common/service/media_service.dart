import 'dart:convert';

import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/model/playlist_filter.dart';
import 'package:unknown/common/model/user.dart';
import 'package:unknown/common/provider/abstract_provider.dart';
import 'package:unknown/common/provider/netease.dart';
import 'package:unknown/common/provider/qq.dart';
import 'package:unknown/common/service/player_service.dart';
import 'package:unknown/common/service/storage.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../model/song.dart';

class MediaController extends GetxController {
  static MediaController get to => Get.find();

  static Map<String, AbstractProvider> providers = {
    Platform.Netease: Netease(),
    Platform.QQ: QQ(),
  };

  changeCookie(String source) {
    providers[source]!.handleChangeCookie();
  }

  String queryStringify(Map<String, String> params) {
    var arr = [];
    params.forEach((key, value) => arr.add("$key=$value"));
    return arr.join("&");
  }

  play(Song song) async {
    var finalSong = await getSongUrl(song);
    if (finalSong.url != "" && !finalSong.disabled) {
      PlayerService.instance.play(finalSong);
    }
  }

  playByID(String platform, String id) {}

  Future<List<Song>?> searchSong(
      String source, int currPage, String keyword) async {
    var result = await providers[source]?.search(keyword, currPage);
    print(jsonEncode(result));
    return result;
  }

  Future<List<Playlist>?> showPlaylistArray(
      String source, int offset, String filterID) async {
    var url = "/show_playlist?${queryStringify({
          "offset": offset.toString(),
          "filter_id": filterID
        })}";
    return await providers[source]?.showPlaylist(url);
  }

  getPlaylistSongs(String source, String url) async {
    return await providers[source]?.getPlaylist(url);
  }

  Future<Song> getSongUrl(Song song, {bool fromDb = false}) async {
    if (fromDb) {
      Song? dbSong = await StorageService.to.getSongById(song.id);
      if (dbSong != null) {
        print("dbsong");
        return dbSong;
      }
    }
    var url = await providers[song.source]?.getSongUrl(song.id);
    song.url = url;
    // StorageService.to.saveSong(song);
    print("new song");
    return song;
  }

  Future<bool> createLocalPlaylist(String name, {String? id}) async {
    id ??= const Uuid().v4();
    var playlist = Playlist("", name, id, "", Platform.LOCAL);
    await StorageService.to.savePlaylist(playlist);
    return true;
  }

  Future<bool> deleteLocalPlaylist(String id) async {
    await StorageService.to.deletePlaylist(id);
    return true;
  }

  Future<bool> saveToLocalPlaylist(Song song, String id) async {
    print(song.id + ":" + id);
    var isExist = await StorageService.to.checkExistSongInPlayList(song.id, id);
    if (isExist) {
      return false;
    }
    song.url = "";
    StorageService.to.saveToPlayList(song, id);
    return true;
  }

  Future<bool> collectToLocal(String name, List<Song> songs) async {
    var id = const Uuid().v4();
    await createLocalPlaylist(name, id: id);
    await StorageService.to.saveAllToPlaylist(songs, id);
    return true;
  }

  Future<List<Song>> getLocalPlaylistSongs(String playlistId) async {
    return await StorageService.to.getPlaylistSongs(playlistId);
  }

  Future<PlaylistFilter> getFilter(String source) async {
    return await providers[source]!.playlistFilter();
  }

  Future<UserModel?> getUserInfo(String source) async {
    return await providers[source]?.getUserInfo();
  }

  Future<List<Song>?> getRecommand(String source) async {
    return await providers[source]?.getUserRecommand();
  }

  Future<List<Playlist>?> getUserPlaylist(String source) async {
    return await providers[source]?.getUserPlayList();
  }

  Future<String> getLyirc(Song song) async {
    return await providers[song.source]?.getLyric(song.id);
  }

  String getLoginUrl(String source) {
    return providers[source]!.getLoginUrl();
  }
}
