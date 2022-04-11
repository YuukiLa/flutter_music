import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/model/category.dart';
import 'package:unknown/common/model/filter.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/model/playlist_filter.dart';
import 'package:unknown/common/provider/abstract_provider.dart';

import '../model/song.dart';

class QQ extends AbstractProvider {
  static final dio = Dio(BaseOptions(headers: {
    "Referer": "https://y.qq.com",
    "Origin": "https://y.qq.com",
    "User-Agent":
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
    "Content-Type": "application/x-www-form-urlencoded"
  }));

  @override
  getPlaylist(String url) {
    var list_id = getUrlParams('list_id', url)?.split('_');
    switch (list_id![0]) {
      case 'qqplaylist':
        return qq_get_playlist(list_id[1]);
      case 'qqalbum':
      // return this.qq_album(url);
      case 'qqartist':
      // return this.qq_artist(url);
      case 'qqtoplist':
      // return this.qq_toplist(url);
      default:
        return null;
    }
  }

  qq_get_playlist(String listId) async {
    var target_url =
        'https://i.y.qq.com/qzone-music/fcg-bin/fcg_ucc_getcdinfo_' +
            'byids_cp.fcg?type=1&json=1&utf8=1&onlysong=0' +
            "&nosign=1&disstid=$listId&g_tk=5381&loginUin=0&hostUin=0" +
            '&format=json&inCharset=GB2312&outCharset=utf-8&notice=0' +
            '&platform=yqq&needNewCode=0';
    var resp = await dio.get(target_url);
    var data = resp.data;
    print(data);
    var info = {
      "cover_img_url": data["cdlist"][0]["logo"],
      "title": data["cdlist"][0]["dissname"],
      "id": "qqplaylist_$listId",
      "source_url": "https://y.qq.com/n/ryqq/playlist/$listId"
    };
    var tracks = <Song>[];
    data["cdlist"][0]["songlist"].forEach((item) => tracks.add(qq_convert_song(item)));
    return {
      "tracks": tracks, "info": info
    };
  }

  Song qq_convert_song(dynamic song) {
    var covert = Song(
        "qqtrack_${song['songmid']}",
        "${htmlParse(song['songname'])}",
        "${htmlParse(song['singer'][0]['name'])}",
        "qqartist_${song['singer'][0]['mid']}",
        "${htmlParse(song['albumname'])}",
        "qqalbum_${song['albummid']}",
        "https://y.qq.com/#type=song&mid=${song['songmid']}&tpl=yqq_song_detail",
        Platform.QQ,
        qq_get_image_url(song["albummid"], 'album'),
        qq_is_playable(song),
        false);
    return covert;
  }

  String qq_get_image_url(String qqimgid, String img_type) {
    if (qqimgid == null) {
      return '';
    }
    var category = '';
    if (img_type == 'artist') {
      category = 'T001R300x300M000';
    }
    if (img_type == 'album') {
      category = 'T002R300x300M000';
    }
    var s = category + qqimgid;
    var url = "https://y.gtimg.cn/music/photo_new/$s.jpg";
    return url;
  }

  qq_is_playable(song) {
    var switch_flag = song["switch"].toString(2).split('');
    switch_flag.pop();
    switch_flag.reverse();
    // flag switch table meaning:
    // ["play_lq", "play_hq", "play_sq", "down_lq", "down_hq", "down_sq", "soso",
    //  "fav", "share", "bgm", "ring", "sing", "radio", "try", "give"]
    var play_flag = switch_flag[0];
    var try_flag = switch_flag[13];
    return play_flag == '1' || (play_flag == '1' && try_flag == '1');
  }

  @override
  getSongUrl(String id) {
    // TODO: implement getSongUrl
  }

  @override
  Future<PlaylistFilter> playlistFilter() async {
    var target_url =
        'https://c.y.qq.com/splcloud/fcgi-bin/fcg_get_diss_tag_conf.fcg' +
            "?picmid=1&rnd=${Random().nextDouble()}&g_tk=732560869" +
            '&loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8' +
            '&notice=0&platform=yqq.json&needNewCode=0';
    var resp = await dio.get(target_url);
    var all = <Category>[];
    var data = jsonDecode(resp.data);
    data["data"]["categories"].forEach((cate) {
      if (cate["usable"] == 1) {
        List<Filter> filters = [];
        cate["items"].forEach((item) {
          filters.add(Filter(
              item["categoryId"].toString(), htmlParse(item["categoryName"])));
        });
        all.add(Category(cate["categoryGroupName"], filters));
      }
    });
    var recommend = [
      Filter("", "全部"),
      Filter("toplist", "排行榜"),
      ...all[1].filters.sublist(0, 8)
    ];
    return PlaylistFilter(recommend, all);
  }

  @override
  Future<List<Playlist>?> showPlaylist(String url) async {
    var offset = getUrlParams('offset', url) ?? 0;
    var filterId = getUrlParams('filter_id', url) ?? '';
    if (filterId == 'toplist') {
      return this.qq_show_toplist(offset);
    }
    if (filterId == '') {
      filterId = '10000000';
    }
    var target_url = 'https://c.y.qq.com/splcloud/fcgi-bin/fcg_get_diss_by_tag.fcg' +
        "?picmid=1&rnd=${Random().nextDouble()}&g_tk=732560869" +
        '&loginUin=0&hostUin=0&format=json&inCharset=utf8&outCharset=utf-8' +
        '&notice=0&platform=yqq.json&needNewCode=0' +
        "&categoryId=$filterId&sortId=5&sin=$offset&ein=${29 + num.parse(offset.toString())}";
    var resp = await dio.get(target_url);
    var data = jsonDecode(resp.data)["data"]["list"];

    var result = <Playlist>[];
    data.forEach((item) => result.add(Playlist(
        item["imgurl"],
        htmlParse(item["dissname"]),
        "qqplaylist_${item['dissid']}",
        "https://y.qq.com/n/ryqq/playlist/${item['dissid']}",
        Platform.QQ)));

    return result;
  }

  qq_show_toplist(offset) {}

  htmlParse(String value) {
    var p = parse(value, encoding: "text/html");
    return p.body?.nodes[0].toString().replaceAll("\"", "") ?? "";
  }
}
