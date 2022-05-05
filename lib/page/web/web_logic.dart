import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/platform.dart';
import 'package:unknown/common/enums/sp_key.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/service/sp_service.dart';
import 'package:unknown/common/utils/dialog.dart';

import 'web_state.dart';

class WebLogic extends GetxController {
  final WebState state = WebState();
  late InAppWebViewController webViewController;
  late var loginUrl;
  late var platform;

  @override
  void onInit() {
    platform = Get.arguments['platform'];
    loginUrl = MediaController.to.getLoginUrl(platform);
    super.onInit();
  }

  getCookie() async{
    if(webViewController==null) {
      DialogUtil.toast("等待页面加载完成...");
      return;
    }

    var cookie = await webViewController.evaluateJavascript(source: "document.cookie");
    if(platform==Platform.Netease) {
      var music_u = await CookieManager.instance().getCookie(url: Uri.parse("https://music.163.com/"), name: "MUSIC_U");
      print(music_u);
      cookie = "$cookie; MUSIC_U=${music_u?.value}";
    }
    await SpService.to.setString(SpKeyConst.getCookieKey(platform), cookie);
    MediaController.to.changeCookie(platform);
    Get.back();
    print(cookie);
  }

  onLoadStop(InAppWebViewController controller, url) async {
    webViewController = controller;
  }
}
