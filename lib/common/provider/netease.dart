import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:unknown/common/model/category.dart';
import 'package:unknown/common/model/filter.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/model/playlist_filter.dart';
import 'dart:math';

class Netease {

  static const channel = const MethodChannel('unknown/neteaseEnc');

  static Future<List<Playlist>?> showPlaylist(String url) async {
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
    var response = await Dio().get(target_url);
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
            "https://music.163.com/#/playlist?id=${getUrlParams('id', item.getElementsByTagName('div')[0].getElementsByTagName('a')[0].attributes["href"] ?? "")}"))
        .toList();
    return result;
  }

  static Future<List<Playlist>> ne_show_toplist(int offset) async {
    return [];
  }

  static weapi(text) async {
    // const modulus = '00e0b509f6259df8642dbc35662901477df22677ec152b5ff68ace615bb7b72' +
    //     '5152b3ab17a876aea8a5aa76d2e417629ec4ee341f56135fccf695280104e0312ecbd' +
    //     'a92557c93870114af6c9d05c4f7f0c3685b7a46bee255932575cce10b424d813cfe48' +
    //     '75d3e82047b97ddef52741d546b8e289dc6935b3ece0462db0a22b8e7';
    // const nonce = '0CoJUm6Qyw8W8jud';
    // const pubKey = '010001';
    // var sec_key = _create_secret_key(16);
    // var enc_text = await _aes_encrypt(text, nonce, 'AES-CBC');
    // enc_text = await _aes_encrypt(enc_text, sec_key, 'AES-CBC');
    var result = await channel.invokeMethod("neteaseAesEnc");
    print("result=$result");
  }
  static Future<String> _aes_encrypt(String text, String sec_key, String algo) async {
    AesCbc aes = AesCbc.with256bits(macAlgorithm: Hmac.sha256());
    var encrypt = await aes.encrypt(utf8.encode(text), secretKey: SecretKey(utf8.encode(sec_key)));
    return utf8.decode(encrypt.cipherText);
  }
  static _rsa_encrypt(String text, String pubKey, String modulus) async {
    text = text.split("").reversed.join("");
    final algorithm = RsaPss(Sha256());
    // BigInt.from();

  }
  static _create_secret_key(int size) {
    const result = [];
    var choice = '012345679abcdef'.split('');
    for (var i = 0; i < size; i += 1) {
      var index = (Random.secure().nextDouble() * choice.length).truncate();
      result.add(choice[index]);
    }
    return result.join('');
  }

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
