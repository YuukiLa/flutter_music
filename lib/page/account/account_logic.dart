import 'dart:convert';

import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/route/app_routes.dart';
import 'package:unknown/common/service/media_service.dart';

import 'account_state.dart';

class AccountLogic extends GetxController {
  final AccountState state = AccountState();

  @override
  onInit() {
    refreshUserInfo();
    super.onInit();
  }

  goto(String platform) {
    Get.toNamed(AppRoutes.WEB, arguments: {"platform": platform});
  }

  refreshUserInfo() async {
    var qqUser = await MediaController.to.getUserInfo(Platform.QQ);
    if (qqUser != null) {
      state.qqUser.value = qqUser;
    }
  }
}
