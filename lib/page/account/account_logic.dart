import 'dart:convert';

import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/enums/sp_key.dart';
import 'package:unknown/common/model/user.dart';
import 'package:unknown/common/route/app_routes.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/service/sp_service.dart';

import 'account_state.dart';

class AccountLogic extends GetxController {
  final AccountState state = AccountState();

  @override
  onInit() {
    var qqUserStr = SpService.to.getString(SpKeyConst.getUserKey(Platform.QQ));
    var neteaseUserStr =
        SpService.to.getString(SpKeyConst.getUserKey(Platform.Netease));
    if (qqUserStr != "") {
      state.qqUser.value = UserModel.fromJson(jsonDecode(qqUserStr));
    }
    if (neteaseUserStr != "") {
      state.neteaseUser.value = UserModel.fromJson(jsonDecode(neteaseUserStr));
    }
    // refreshUserInfo();
    super.onInit();
  }

  goto(String platform) {
    Get.toNamed(AppRoutes.WEB, arguments: {"platform": platform});
  }

  gotoRecommand(String platform) {
    Get.toNamed(AppRoutes.SONG_LIST,
        arguments: {"platform": platform, "recommand": true});
  }

  refreshUserInfo() async {
    var qqUser = await MediaController.to.getUserInfo(Platform.QQ);
    if (qqUser != null) {
      state.qqUser.value = qqUser;
      SpService.to
          .setString(SpKeyConst.getUserKey(Platform.QQ), jsonEncode(qqUser));
    }
    var neteaseUser = await MediaController.to.getUserInfo(Platform.Netease);
    if (neteaseUser != null) {
      state.neteaseUser.value = neteaseUser;
      SpService.to.setString(
          SpKeyConst.getUserKey(Platform.Netease), jsonEncode(neteaseUser));
    }
  }

  gotoPlaylist(String platform) async {
    Get.toNamed(AppRoutes.USER_PLAYLIST,arguments: {"platform": platform});
  }
}
