import 'dart:convert' as convert;
import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:dio_log/interceptor/dio_log_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/enums/sp_key.dart';
import 'package:unknown/common/model/category.dart';
import 'package:unknown/common/model/filter.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/model/playlist_filter.dart';
import 'package:unknown/common/model/user.dart';
import 'package:unknown/common/provider/abstract_provider.dart';
import 'package:unknown/common/service/sp_service.dart';

import '../model/song.dart';

class Netease extends AbstractProvider {
  static const channel = MethodChannel('unknown/neteaseEnc');
  late Dio dio;
  Netease() {
    _initDio();
  }

  @override
  handleChangeCookie() {
    _initDio();
  }

  _initDio() {
    var cookie =
        SpService.to.getString(SpKeyConst.getCookieKey(Platform.Netease));
    if (cookie == "") {
      cookie = "NMTID=00OV7gTWb1-5yFN3kAujDgyS5pvnkEAAAGAYSrsGQ";
    }
    dio = Dio(BaseOptions(headers: {
      "Referer": "https://music.163.com",
      "Origin": "https://music.163.com",
      "authority": "music.163.com",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
      "Content-Type": "application/x-www-form-urlencoded",
      "cookie": cookie,
      // "cookie": "_iuqxldmzr_=32; _ntes_nuid=a82ed4abdad948ae4ecdba71bf4ba8a8; WM_TID=GkalpOJKWpFAQVRFAEdvEuu2zrQKC3uj; _ntes_nnid=a82ed4abdad948ae4ecdba71bf4ba8a8,1622347505950; NMTID=00O-xs9VfjspuHjMEIBoCUi6aeNrl4AAAF6V_oUvA; WEVNSM=1.0.0; WNMCID=qvblxb.1624973645128.01.0; _ns=NS1.2.1778974413.1641207971; JSESSIONID-WYYY=WmQhiZ4Y%5CfwtD%5CkSBWBvKEHMn%2FcIf1Es4pq4ilt66%5CsVN86uJvomaCBtBv4e9nIIJZylT%2FVYKOM6K2rEtAOlDdnKzey9Yx4MggjqCTBauewfSDt8us3JDX2dNqQNwnPjgqT46FVmvwx6%5CxzFuxqjF04vuu%5ChE7ibZBFsHxHQZQW%5CNdpI%3A1643693262143; WM_NI=ylzrpufQYoFhs6M4o3XQWKTWuLGnpzpD2yfX6%2FQ%2BIAGyGLO71iqHoMSnLIUbDAog%2FHe1eDKbEHNNyof2ZyDskFaOmirN1W31JLQhIPXQ%2FnC474eOoEiYPYr9Z0ARQ%2FQZT2E%3D; WM_NIKE=9ca17ae2e6ffcda170e2e6ee96e57eb3eff8a3ce44a8968aa7c14f868f8abbaa7a8fb0af8bd670acb1fb90c12af0fea7c3b92abbb4b693f37fa68f9790c564b1ea83d5ee399c8f99acd75db794898ff372b49cfe9ae554f6f19fcccc4b85a789adce3df3b7bfa9ee4791b284aad86a889fa188ae44a7efaba5ca6a879882affc65a6ee969ac779a99aafb0f063b292ffb8b23b8a949f89cc5c9c8fe18fc240f5ecabb0ee4fab87a0baf1339af08fb3d42593869cd3c837e2a3"
    }));
  }
  // ..interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options,RequestInterceptorHandler handler) {
  //   print(
  //       "\n================================= ???????????? =================================");
  //   print("method = ${options.method.toString()}");
  //   print("url = ${options.uri.toString()}");
  //   print("headers = ${options.headers}");
  //   print("params = ${options.queryParameters}");
  //   handler.next(options);
  // },onResponse: (Response response,ResponseInterceptorHandler handler) {
  //   print(
  //       "\n================================= ?????????????????? =================================");
  //   print("code = ${response.statusCode}");
  //   print("data = ${response.data}");
  //   print(
  //       "================================= ?????????????????? =================================\n");
  //   handler.next(response);
  // }, onError: (DioError e,ErrorInterceptorHandler handler) {
  //   print(
  //       "\n=================================?????????????????? =================================");
  //   print("type = ${e.type}");
  //   print("message = ${e.message}");
  //   print("stackTrace = ${e.stackTrace}");
  //   print("\n");
  //   handler.next(e);
  // }));

  Future<List<Playlist>?> showPlaylist(String url) async {
    const order = 'hot';
    print(url);

    var offset = int.parse(getUrlParams('offset', url) ?? "1");
    var filterId = getUrlParams('filter_id', url);

    if (filterId == 'toplist') {
      return ne_show_toplist(offset);
    }
    var filter = '';
    if (filterId != '') {
      filter = "&cat=$filterId";
    }
    var target_url = '';
    if (offset != "") {
      target_url =
          "https://music.163.com/discover/playlist/?order=$order$filter&limit=35&offset=$offset";
    } else {
      target_url =
          "https://music.163.com/discover/playlist/?order=$order$filter";
    }
    var response = await dio.get(target_url);
    Document doc = parse(response.data);
    var children = doc.getElementsByClassName("m-cvrlst")[0].children;
    var result = children
        .map((item) => Playlist(
            item.getElementsByTagName("img")[0].attributes["src"] ?? "",
            item
                    .getElementsByTagName('div')[0]
                    .getElementsByTagName('a')[0]
                    .attributes["title"] ??
                "",
            "neplaylist_${getUrlParams('id', item.getElementsByTagName('div')[0].getElementsByTagName('a')[0].attributes["href"] ?? "")}",
            "https://music.163.com/#/playlist?id=${getUrlParams('id', item.getElementsByTagName('div')[0].getElementsByTagName('a')[0].attributes["href"] ?? "")}",
            Platform.Netease))
        .toList();
    return result;
  }

  static Future<List<Playlist>> ne_show_toplist(int offset) async {
    return [];
  }

  @override
  getLyric(String id) async {
    // use chrome extension to modify referer.
    const target_url = 'https://music.163.com/weapi/song/lyric?csrf_token=';
    const csrf = '';
    var d = {
      "id": id.split("_")[1],
      "lv": -1,
      "tv": -1,
      "csrf_token": csrf,
    };
    var data = await weapi(convert.jsonEncode(d));
    var resp = await dio.post(target_url, data: data);
    Map<String, dynamic> respData = convert.jsonDecode(resp.data);
    var lrc = "";
    // var tlrc = "";
    if (respData["lrc"] != null) {
      lrc = respData["lrc"]["lyric"];
    }
    // if (respData["tlyric"] != null && respData["tlyric"]["lyric"] != null) {
    //   // eslint-disable-next-line no-control-regex
    //   RegExp(/(|\\)/g)
    //   tlrc = respData["tlyric"]["lyric"].replaceAll(, '');

    //   tlrc = tlrc.replace(/[\u2005]+/g, ' ');
    // }
    return lrc;
  }

  @override
  getPlaylist(String url) {
    print(url);
    var list_id = getUrlParams('list_id', url)?.split('_').first;
    switch (list_id) {
      case 'neplaylist':
        return ne_get_playlist(url);
      // case 'nealbum':
      //   return this.ne_album(url);
      // case 'neartist':
      //   return this.ne_artist(url);
      default:
        return null;
    }
  }

  Future<Map<String, dynamic>> ne_get_playlist(String url) async {
    var list_id = getUrlParams('list_id', url)?.split('_').last;
    const target_url = 'https://music.163.com/weapi/v3/playlist/detail';
    print(list_id);
    var d = {
      "id": list_id,
      "offset": 0,
      "total": true,
      "limit": 1000,
      "n": 1000,
      "csrf_token": ''
    };
    var req = await weapi(convert.jsonEncode(d));
    var resp = await dio.post(target_url, data: req);
    Map<String, dynamic> data = convert.jsonDecode(resp.data);
    var info = {
      "id": "neplaylist_$list_id",
      "cover_img_url": data["playlist"]["coverImgUrl"],
      "title": data["playlist"]["name"],
      "source_url": "https://music.163.com/#/playlist?id=$list_id"
    };
    var trackIdsArray = split_array(data["playlist"]["trackIds"], 1000);
    var tracks = <Song>[];
    for (var id in trackIdsArray) {
      tracks.addAll(await ng_parse_playlist_tracks(id));
    }
    return {"tracks": tracks, "info": info};
  }

  static weapi(text) async {
    var modulus = '00e0b509f6259df8642dbc35662901477df22677ec152b5ff68ace615bb7b72' +
        '5152b3ab17a876aea8a5aa76d2e417629ec4ee341f56135fccf695280104e0312ecbd' +
        'a92557c93870114af6c9d05c4f7f0c3685b7a46bee255932575cce10b424d813cfe48' +
        '75d3e82047b97ddef52741d546b8e289dc6935b3ece0462db0a22b8e7';
    var nonce = '0CoJUm6Qyw8W8jud';
    var pubKey = '010001';
    var sec_key = _create_secret_key(16);
    var aes = await channel
        .invokeMethod("neteaseAesEnc", {"text": text, "key": nonce});
    aes = await channel
        .invokeMethod("neteaseAesEnc", {"text": aes, "key": sec_key});
    var rsa = await channel.invokeMethod("neteaseRsaEnc",
        {"text": sec_key, "pubKey": pubKey, "modulus": modulus});
    return {"params": aes, "encSecKey": rsa};
  }

  static List<dynamic> split_array(List<dynamic> myarray, int size) {
    var count = (myarray.length / size).ceil();
    var result = [];
    for (var i = 0; i < count; i += 1) {
      if (myarray.length < size) {
        result.add(myarray);
      } else {
        result.add(myarray.slice(i * size, (i + 1) * size));
      }
    }
    return result;
  }

  ng_parse_playlist_tracks(List<dynamic> playlist_tracks) async {
    const target_url = 'https://music.163.com/weapi/v3/song/detail';
    var track_ids = playlist_tracks.map((i) => i["id"]);
    var d = {
      "c": "[${track_ids.map((id) => '{"id":$id}').join(',')}]",
      "ids": "[${track_ids.join(',')}]"
    };
    var data = await weapi(convert.jsonEncode(d));
    var response = await dio.post(target_url, data: data);
    var res = convert.jsonDecode(response.data);
    var songs = res["songs"] as List<dynamic>;
    var tracks = songs.map((track_json) => Song(
        "netrack_${track_json["id"]}",
        track_json["name"],
        track_json["ar"][0]["name"],
        "neartist_${track_json["ar"][0]["id"]}",
        track_json["al"]["name"],
        "nealbum_${track_json["al"]["id"]}",
        "https://music.163.com/#/song?id=${track_json["id"]}",
        'netease',
        track_json["al"]["picUrl"],
        track_json["dt"],
        "",
        !is_playable(track_json)));
    return tracks;
  }

  getSongUrl(String id) async {
    id = id.split("_")[1];
    var data = {
      "ids": [id],
      "br": "999000"
    };
    var resp = await dio.post(
        "http://music.163.com/weapi/song/enhance/player/url?csrf_token=",
        data: await weapi(convert.jsonEncode(data)));
    var resData = convert.jsonDecode(resp.data);
    return resData["data"]?[0]?["url"] ?? "";
  }

  static _create_secret_key(int size) {
    final _random = Random();
    const _availableChars = '0123456789abcdef';
    final randomString = List.generate(size,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }

  Future<PlaylistFilter> playlistFilter() async {
    var recommend = [
      Filter("", "??????"),
      Filter("toplist", "?????????"),
      Filter("??????", "??????"),
      Filter("??????", "??????"),
      Filter("??????", "??????"),
      Filter("??????", "??????"),
      Filter("??????", "??????"),
      Filter("?????????", "?????????"),
      Filter("??????", "??????"),
      Filter("??????", "??????"),
    ];
    var all = [
      Category("??????", [
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
      ]),
      Category("??????", [
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("?????????", "?????????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("R%26B%2FSoul", "R%26B%2FSoul"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("????????????", "????????????"),
        Filter("??????", "??????"),
        Filter("New Age", "New Age"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("Bossa Nova", "Bossa Nova")
      ]),
      Category("??????", [
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("?????????", "?????????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????")
      ]),
      Category("??????", [
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????")
      ]),
      Category("??????", [
        Filter("??????", "??????"),
        Filter("????????????", "????????????"),
        Filter("ACG", "ACG"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("70???", "70???"),
        Filter("80???", "80???"),
        Filter("90???", "90???"),
        Filter("????????????", "????????????"),
        Filter("KTV", "KTV"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("??????", "??????"),
        Filter("00???", "00???")
      ]),
    ];
    return PlaylistFilter(recommend, all);
  }

  @override
  Future<List<Song>> search(String keyword, int currPage) async {
    const target_url = 'https://music.163.com/api/search/pc';
    var req_data = {
      "s": keyword,
      "offset": 20 * (currPage - 1),
      "limit": 20,
      "type": "1"
    };
    var resp = await dio.post(target_url, data: req_data);
    var data = convert.jsonDecode(resp.data);
    print(data.toString());

    var result = <Song>[];
    data["result"]["songs"].forEach((song_info) {
      result.add(Song(
          "netrack_${song_info['id']}",
          song_info["name"],
          song_info["artists"][0]["name"],
          "neartist_${song_info['artists'][0]['id']}",
          song_info["album"]["name"],
          "nealbum_${song_info['album']['id']}",
          "https://music.163.com/#/song?id=${song_info['id']}",
          "netease",
          song_info["album"]["picUrl"],
          song_info["duration"],
          "",
          !is_playable(song_info)));
    });
    return result;
  }

  bool is_playable(song) {
    return song["fee"] != 4 && song["fee"] != 1;
  }

  @override
  String getLoginUrl() {
    return "https://music.163.com/#/login";
  }

  @override
  getUserInfo() async {
    var cookie =
        SpService.to.getString(SpKeyConst.getCookieKey(Platform.Netease));
    if (cookie == "") {
      return null;
    }
    const url = "https://music.163.com/api/nuser/account/get";
    var encrypt_req_data = await weapi(convert.jsonEncode({}));
    var resp = await dio.post(url, data: encrypt_req_data);
    var data = resp.data;
    if (data["account"] != null) {
      return UserModel(
          data["profile"]["userId"].toString(),
          data["profile"]["nickname"],
          data["profile"]["avatarUrl"],
          Platform.Netease);
    }
    return null;
  }

  @override
  getUserPlayList() async {
    UserModel user = UserModel.fromJson(convert.jsonDecode(
        SpService.to.getString(SpKeyConst.getUserKey(Platform.Netease))));
    var targetUrl = "https://music.163.com/api/user/playlist";
    var req_data = {
      "uid": user.id,
      "limit": 1000,
      "offset": 0,
      "includeVideo": true,
    };
    var resp = await dio.post(targetUrl, data: req_data);
    var data = convert.jsonDecode(resp.data);
    var list = <Playlist>[];
    data["playlist"].forEach((item) {
      var playlist = Playlist(
          item["coverImgUrl"],
          item["name"],
          "neplaylist_${item['id']}",
          "https://music.163.com/#/playlist?id=${item['id']}",
          Platform.Netease);
      playlist.isSub = item["subscribed"];
      playlist.count = item["trackCount"];
      list.add(playlist);
    });
    return list;
  }

  @override
  getUserRecommand() async {
    var targetUrl = "https://music.163.com/weapi/v2/discovery/recommend/songs";
    var resp =
        await dio.post(targetUrl, data: await weapi(convert.jsonEncode({})));
    var data = convert.jsonDecode(resp.data);
    var list = <Song>[];
    data["recommend"].forEach((song_info) {
      list.add(Song(
          "netrack_${song_info['id']}",
          song_info["name"],
          song_info["artists"][0]["name"],
          "neartist_${song_info['artists'][0]['id']}",
          song_info["album"]["name"],
          "nealbum_${song_info['album']['id']}",
          "https://music.163.com/#/song?id=${song_info['id']}",
          "netease",
          song_info["album"]["picUrl"],
          song_info["duration"],
          "",
          !is_playable(song_info)));
    });
    return list;
  }

  _recommandPlaylist() async {
    const target_url = 'https://music.163.com/weapi/personalized/playlist';

    var req_data = {
      "limit": 30,
      "total": true,
      "n": 1000,
    };
    var req = await weapi(convert.jsonEncode(req_data));
    var resp = await dio.post(target_url, data: req);
    var data = resp.data;
    var list = <Playlist>[];
    data['result'].forEach((e) {
      list.add(Playlist(e['picUrl'], e['name'], "neplaylist_${e['id']}",
          "https://music.163.com/#/playlist?id=${e['id']}", Platform.Netease));
    });
    return list;
  }

  // static String? getUrlParams(String key, String url) {
  //   if (url == "") {
  //     return null;
  //   }
  //   var parse = Uri.parse(url);
  //   return parse.queryParameters[key];
  // }
}
