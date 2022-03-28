
import 'package:get/get.dart';

import '../../page/main/main_index.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> pages() {
    return [
      GetPage(
          name: AppRoutes.INITIAL,
          page: ()=> MainPage(),
          binding: MainBinding()
      )
    ];
  }
}