import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/service/player_service.dart';
import 'package:unknown/common/service/sp_service.dart';
import 'package:unknown/common/service/storage.dart';

class Global {
  static Future init() async{
    WidgetsFlutterBinding.ensureInitialized();
    setSystemUi();
    await Get.putAsync<StorageService>(() => StorageService().init());
    await Get.putAsync<SpService>(() => SpService().init());
    await Get.putAsync<PlayerService>(() => PlayerService().init());
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