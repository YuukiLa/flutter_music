import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unknown/common/service/media_service.dart';

class Global {
  static Future init() async{
    setSystemUi();
    Get.put<MediaController>(MediaController());
  }
  static void setSystemUi() {

    if (GetPlatform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarBrightness: Brightness.light,
        // statusBarIconBrightness: Brightness.dark,
        // systemNavigationBarDividerColor: Colors.transparent,
        // systemNavigationBarColor: Colors.white,
        // systemNavigationBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}