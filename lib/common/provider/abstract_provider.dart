import 'package:dio/dio.dart';

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
  getLyric(String id);
  Future<List<Song>> search(String keyword, int currPage);

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

  addInterceptors(Dio dio) {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      print(
          "\n================================= 请求数据 =================================");
      print("method = ${options.method.toString()}");
      print("url = ${options.uri.toString()}");
      print("headers = ${options.headers}");
      print("params = ${options.queryParameters}");
      handler.next(options);
    }, onResponse: (Response response, ResponseInterceptorHandler handler) {
      print(
          "\n================================= 响应数据开始 =================================");
      print("code = ${response.statusCode}");
      print("data = ${response.data}");
      print(
          "================================= 响应数据结束 =================================\n");
      handler.next(response);
    }, onError: (DioError e, ErrorInterceptorHandler handler) {
      print(
          "\n=================================错误响应数据 =================================");
      print("type = ${e.type}");
      print("message = ${e.message}");
      print("stackTrace = ${e.stackTrace}");
      print("\n");
      handler.next(e);
    }));
  }
}
