
import 'package:get/get.dart';
import 'package:unknown/page/song_list/song_list_index.dart';

import '../../page/main/main_index.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> pages() {
    return [
      GetPage(
          name: AppRoutes.INITIAL,
          page: ()=> MainPage(),
          binding: MainBinding()
      ),
      GetPage(
          name: AppRoutes.SONG_LIST,
          page: ()=> SongListPage(),
          binding: SongListBinding()
      )
    ];
  }
}