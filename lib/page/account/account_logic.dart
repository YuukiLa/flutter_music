import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/enums/sp_key.dart';
import 'package:unknown/common/model/user.dart';
import 'package:unknown/common/route/app_routes.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/service/sp_service.dart';
import 'package:unknown/common/service/storage.dart';
import 'package:unknown/common/utils/dialog.dart';

import 'account_state.dart';

class AccountLogic extends GetxController {
  final AccountState state = AccountState();

  late TextEditingController textEditingController;

  @override
  onInit() {
    textEditingController = TextEditingController();
    getLocalPlayList();
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

  onTextChange(String text) {
    state.playlistName.value = text;
  }

  goto(String platform) {
    Get.toNamed(AppRoutes.WEB, arguments: {"platform": platform});
  }

  gotoRecommand(String platform) {
    Get.toNamed(AppRoutes.SONG_LIST,
        arguments: {"platform": platform, "type": 1});
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
    Get.toNamed(AppRoutes.USER_PLAYLIST, arguments: {"platform": platform});
  }

  gotoLocalPlaylist(String playlistId, String title) async {
    Get.toNamed(AppRoutes.SONG_LIST,
        arguments: {"type": 2, "id": playlistId, "title": title});
  }

  void createPlaylist(BuildContext context) async {
    await MediaController.to.createLocalPlaylist(state.playlistName.value);
    state.playlistName.value = "";
    Navigator.pop(context);
    DialogUtil.toast("创建成功");
    getLocalPlayList();
  }

  getLocalPlayList() async {
    var list = await StorageService.to.getPlaylists();
    state.localPlaylist.clear();
    state.localPlaylist.addAll(list);
  }

  removeLocalPlaylist(String id) async {
    await MediaController.to.deleteLocalPlaylist(id);
    getLocalPlayList();
    DialogUtil.toast("删除成功");
  }
}
