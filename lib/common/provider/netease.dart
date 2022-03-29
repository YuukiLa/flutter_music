import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:unknown/common/model/category.dart';
import 'package:unknown/common/model/filter.dart';
import 'package:unknown/common/model/playlist_filter.dart';

class Netease {
  static showPlaylist(String url) async {
    const order = 'hot';
    print(url);

    var offset =  int.parse(getUrlParams('offset', url)?? "1");
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
      target_url = "https://music.163.com/discover/playlist/?order=$order$filter&limit=35&offset=$offset";
    } else {
      target_url = "https://music.163.com/discover/playlist/?order=$order$filter";
    }
    var response = await Dio().get(target_url);
    Document doc = parse(response.data);
    var children = doc.getElementsByClassName("m-cvrlst")[0].children;
    var result = children.map((item) => {
      "cover_img_url": item.getElementsByTagName("img")[0].attributes["src"],
      "title": item.getElementsByTagName('div')[0].getElementsByTagName('a')[0].attributes["title"],
      "id" : "neplaylist_${getUrlParams('id', item.getElementsByTagName('div')[0].getElementsByTagName('a')[0].attributes["href"]??"")}",
      "source_url":"https://music.163.com/#/playlist?id=${getUrlParams('id', item.getElementsByTagName('div')[0].getElementsByTagName('a')[0].attributes["href"]??"")}"
    });
    print(result);
  }

  static ne_show_toplist(int offset) {}

  static PlaylistFilter playlistFilter() {
    var recommend = [
      Filter("", "全部"),
      Filter("toplist", "排行榜"),
      Filter("流行", "流行"),
      Filter("民谣", "民谣"),
      Filter("电子", "电子"),
      Filter("舞曲", "舞曲"),
      Filter("说唱", "说唱"),
      Filter("轻音乐", "轻音乐"),
      Filter("爵士", "爵士"),
      Filter("乡村", "乡村"),
    ];
    var all = [
      Category("语种", [
        Filter("华语", "华语"),
        Filter("欧美", "欧美"),
        Filter("日语", "日语"),
        Filter("韩语", "韩语"),
        Filter("粤语", "粤语"),
      ]),
      Category("风格", [
        Filter("流行", "流行"),
        Filter("民谣", "民谣"),
        Filter("电子", "电子"),
        Filter("舞曲", "舞曲"),
        Filter("说唱", "说唱"),
        Filter("轻音乐", "轻音乐"),
        Filter("爵士", "爵士"),
        Filter("乡村", "乡村"),
        Filter("R%26B%2FSoul", "R%26B%2FSoul"),
        Filter("古典", "古典"),
        Filter("民族", "民族"),
        Filter("英伦", "英伦"),
        Filter("金属", "金属"),
        Filter("朋克", "朋克"),
        Filter("蓝调", "蓝调"),
        Filter("雷鬼", "雷鬼"),
        Filter("世界音乐", "世界音乐"),
        Filter("拉丁", "拉丁"),
        Filter("New Age", "New Age"),
        Filter("古风", "古风"),
        Filter("后摇", "后摇"),
        Filter("Bossa Nova", "Bossa Nova")
      ]),
      Category("场景", [
        Filter("清晨", "清晨"),
        Filter("夜晚", "夜晚"),
        Filter("学习", "学习"),
        Filter("工作", "工作"),
        Filter("午休", "午休"),
        Filter("下午茶", "下午茶"),
        Filter("地铁", "地铁"),
        Filter("驾车", "驾车"),
        Filter("运动", "运动"),
        Filter("旅行", "旅行"),
        Filter("散步", "散步"),
        Filter("酒吧", "酒吧")
      ]),
      Category("情感", [
        Filter("怀旧", "怀旧"),
        Filter("清新", "清新"),
        Filter("浪漫", "浪漫"),
        Filter("伤感", "伤感"),
        Filter("治愈", "治愈"),
        Filter("放松", "放松"),
        Filter("孤独", "孤独"),
        Filter("感动", "感动"),
        Filter("兴奋", "兴奋"),
        Filter("快乐", "快乐"),
        Filter("安静", "安静"),
        Filter("思念", "思念")
      ]),
      Category("主题", [
        Filter("综艺", "综艺"),
        Filter("影视原声", "影视原声"),
        Filter("ACG", "ACG"),
        Filter("儿童", "儿童"),
        Filter("校园", "校园"),
        Filter("游戏", "游戏"),
        Filter("70后", "70后"),
        Filter("80后", "80后"),
        Filter("90后", "90后"),
        Filter("网络歌曲", "网络歌曲"),
        Filter("KTV", "KTV"),
        Filter("经典", "经典"),
        Filter("翻唱", "翻唱"),
        Filter("吉他", "吉他"),
        Filter("钢琴", "钢琴"),
        Filter("器乐", "器乐"),
        Filter("榜单", "榜单"),
        Filter("00后", "00后")
      ]),
    ];
    return PlaylistFilter(recommend, all);
  }

  static String? getUrlParams(String key, String url) {
    if (url == "") {
      return null;
    }
    var parse = Uri.parse(url);
    return parse.queryParameters[key];
  }
}
