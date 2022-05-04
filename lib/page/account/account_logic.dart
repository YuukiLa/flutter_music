import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/route/app_routes.dart';

import 'account_state.dart';

class AccountLogic extends GetxController {
  final AccountState state = AccountState();


  goto(String platform) {
    Get.toNamed(AppRoutes.WEB,arguments: {"platform":platform});
  }


}
