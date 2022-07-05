import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:unknown/common/enums/play_mode.dart';
import 'package:unknown/common/enums/play_state.dart';
import 'package:unknown/common/service/audio_player_handler.dart';

import '../model/song.dart';

class PlayerService extends GetxService {
  static PlayerService instance = Get.find();
  late UnknownAudioPlayerHandler _audioHandler;
  Rx<PlayState> playState = PlayState.STOP.obs;
  Rx<PlayMode> playMode = PlayMode.SEQUENCE.obs;
  Rx<Song> currSong = Song("", "无播放源", "", "", "", "", "", "",
          "images/common/music.png", 0, "", true)
      .obs;
  Rx<String> lyric = "".obs;
  UnknownAudioPlayerHandler get audioHandler => _audioHandler;

  Future<PlayerService> init() async {
    _audioHandler = await AudioService.init(
      builder: () => UnknownAudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'cc.yuuki.unknown',
        androidNotificationChannelName: 'unknown music',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        preloadArtwork: true,
        androidShowNotificationBadge: false,
      ),
    );
    _listenToPlaybackState();
    _listenSongChange();
    if (_audioHandler.songList.isNotEmpty) {
      currSong.value = _audioHandler.currPlaying;
      lyric.value = _audioHandler.lyric;
    }
    return this;
  }

  void _listenSongChange() {
    _audioHandler.setSongChangeListener((Song song) {
      currSong.value = song;
      lyric.value = _audioHandler.lyric;
    });
  }

  //监听播放状态
  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        // 加载中
        playState.value = PlayState.LOADING;
      } else if (!isPlaying) {
        // 没有播放
        playState.value = PlayState.PAUSE;
      } else if (processingState != AudioProcessingState.completed) {
        // 播放中
        playState.value = PlayState.PALYING;
      } else if (isPlaying) {
        // playButtonNotifier.value = ButtonState.playing;
      }
    });
  }

  play(Song song) async {
    print(song.url);
    await _audioHandler.addSong(song);
    _audioHandler.playIndex(_audioHandler.curIndex);
    // _audioHandler.play();
  }

  playSongs(List<Song> songs) {
    _audioHandler.changeQueueLists(songs);
  }

  playIndex(int index) {
    _audioHandler.playIndex(index);
  }

  resume() {
    _audioHandler.play();
  }

  pause() {
    _audioHandler.pause();
  }

  seek(double position) {
    _audioHandler.seek(Duration(milliseconds: position.toInt()));
  }

  next() {
    _audioHandler.skipToNext();
  }

  previous() {
    _audioHandler.skipToPrevious();
  }

  changePlayMode() {
    switch (playMode.value) {
      case PlayMode.SEQUENCE:
        playMode.value = PlayMode.RANDOM;
        _audioHandler.setPlayMode(PlayMode.RANDOM);
        break;
      case PlayMode.RANDOM:
        playMode.value = PlayMode.SINGLE;
        _audioHandler.setPlayMode(PlayMode.SINGLE);
        break;
      case PlayMode.SINGLE:
        playMode.value = PlayMode.SEQUENCE;
        _audioHandler.setPlayMode(PlayMode.SEQUENCE);
        break;
    }
  }

  StreamSubscription<Duration> addPlayingListener(Function call) {
    var listen = AudioService.position.listen((position) {
      call(position);
    });
    return listen;
  }

  removePlayingListener(StreamSubscription<Duration> listen) {
    listen.cancel();
  }
}
