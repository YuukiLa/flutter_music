import 'package:get/get.dart';
import 'package:unknown/common/model/song.dart';
import 'package:unknown/common/service/storage.dart';

import 'player_state.dart';

class PlayerLogic extends GetxController {
  final PlayerState state = PlayerState();


  saveSong() {
    StorageService.to.saveSong(Song("id2", "title334", "artist", "artistId", "album", "albumId", "sourceUrl", "source", "imgUrl", "url", false));
  }

  getSong() async{
    var song = await StorageService.to.getSongById("id2");
    print(song?.title);
  }

}
