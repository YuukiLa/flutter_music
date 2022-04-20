
import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:unknown/common/service/audio_player_handler.dart';

import '../model/song.dart';

class PlayerService extends GetxService {
  static PlayerService instance = Get.find();
  late UnknownAudioPlayerHandler _audioHandler;
  UnknownAudioPlayerHandler get audioHandler => _audioHandler;

  Future<PlayerService> init() async{
    _audioHandler = await AudioService.init(
      builder: ()=> UnknownAudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'cc.yuuki.unknown',
        androidNotificationChannelName: 'unknown music',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        preloadArtwork: true,
        androidShowNotificationBadge: true,
      ),
    );
    return this;
  }


  play(Song song) async {
    print(song.url);
    _audioHandler.playFromSong(song);
    // _audioHandler.play();
  }
}