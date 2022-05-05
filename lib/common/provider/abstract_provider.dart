import '../model/playlist.dart';
import '../model/playlist_filter.dart';
import '../model/song.dart';

abstract class AbstractProvider {
  Future<List<Playlist>?> showPlaylist(String url);
  getPlaylist(String url);
  getSongUrl(String id);
  Future<PlaylistFilter> playlistFilter();
  String getLoginUrl();
  handleChangeCookie();
  getUserInfo();
  getUserPlayList();
  getUserRecommand();

  String? getUrlParams(String key, String url) {
    if (url == "") {
      return null;
    }
    var parse = Uri.parse(url);
    return parse.queryParameters[key];
  }

  String? getCookieParam(String cookie, String key) {
    if (cookie == "") {
      return null;
    }
    var map = {};
    cookie.split(";").forEach((e) {
      var eIndex = e.indexOf("=");

      map[e.substring(0, eIndex).trim()] = e.substring(eIndex + 1).trim();
    });

    return map[key] ?? "";
  }

  Future<List<Song>> search(String keyword, int currPage);
}
