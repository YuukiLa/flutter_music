import 'package:get/get.dart';
import 'package:unknown/page/player/player_index.dart';
import 'package:unknown/page/search/search_index.dart';
import 'package:unknown/page/song_list/song_list_index.dart';
import 'package:unknown/page/web/web_index.dart';

import '../../page/main/main_index.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> pages() {
    return [
      GetPage(
          name: AppRoutes.INITIAL,
          page: () => MainPage(),
          binding: MainBinding(),
          transition: Transition.rightToLeft),
      GetPage(
          name: AppRoutes.SONG_LIST,
          page: () => SongListPage(),
          binding: SongListBinding(),
          transition: Transition.rightToLeft),
      GetPage(
          name: AppRoutes.SEARCH,
          page: () => SearchPage(),
          binding: SearchBinding(),
          transition: Transition.rightToLeft),
      GetPage(
          name: AppRoutes.PLAYER,
          page: () => PlayerPage(),
          binding: PlayerBinding(),
          transition: Transition.downToUp),
      GetPage(
          name: AppRoutes.WEB,
          page: () => WebPage(),
          binding: WebBinding(),
          transition: Transition.rightToLeft)
    ];
  }
}
