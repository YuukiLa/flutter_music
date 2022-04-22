import 'package:get/instance_manager.dart';
import 'package:unknown/page/search/search_logic.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchLogic());
  }
}
