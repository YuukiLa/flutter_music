import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:unknown/common/model/category.dart';
import 'package:unknown/common/model/filter.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/model/playlist_filter.dart';
import 'package:unknown/common/provider/abstract_provider.dart';

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
    // TODO: implement getPlaylist
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
        "https://y.qq.com/n/ryqq/playlist/${item['dissid']}")));

    return result;
  }

  qq_show_toplist(offset) {}

  htmlParse(String value) {
    var p = parse(value, encoding: "text/html");
    return p.body?.nodes[0].toString().replaceAll("\"", "") ?? "";
  }
}
