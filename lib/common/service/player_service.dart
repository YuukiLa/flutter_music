
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../model/song.dart';

class PlayerService extends GetxService {
  static PlayerService instance = Get.find();
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioCache _audioCache = AudioCache();


  Future<PlayerService> init() async{
    if (Platform.isIOS) {
      _audioCache.fixedPlayer?.notificationService.startHeadlessService();
    }
    return this;
  }

  play(Song song) async {
    var result = await _audioPlayer.play(song.url);
    if(result!=1) {
      print("play error");
    }
  }
}