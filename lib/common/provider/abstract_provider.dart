import '../model/playlist.dart';
import '../model/playlist_filter.dart';

abstract class AbstractProvider {
  Future<List<Playlist>?> showPlaylist(String url);
  getPlaylist(String url);
  getSongUrl(String id);
  Future<PlaylistFilter> playlistFilter();

  String? getUrlParams(String key, String url) {
    if (url == "") {
      return null;
    }
    var parse = Uri.parse(url);
    return parse.queryParameters[key];
  }
}