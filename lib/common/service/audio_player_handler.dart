import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:unknown/common/enums/play_mode.dart';
import 'package:unknown/common/service/media_service.dart';
import 'package:unknown/common/utils/dialog.dart';

import '../model/song.dart';

abstract class AudioPlayerHandler implements AudioHandler {
  // 添加公共方法
  Future<void> addSong(Song song);
  Future<void> changeQueueLists(List<Song> songs, {int index = 0});
  Future<void> readySongUrl();
  Future<void> playIndex(int index);
}

class UnknownAudioPlayerHandler extends BaseAudioHandler
    with SeekHandler
    implements AudioPlayerHandler {
  final _emptySong = Song(
      "", "无播放源", "", "", "", "", "", "", "images/common/bet.png", 0, "", true);
  final _player = AudioPlayer();
  final _songlist = <Song>[];
  late Function _songChangeListener;
  PlayMode _playMode=PlayMode.SEQUENCE;
  int _curIndex = 0;
  //记录上一首的位置用于随机模式
  int _preIndex = 0;
  UnknownAudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _listenPlayEnd();
  }

  int get curIndex => _curIndex;
  Song get currPlaying =>
      _songlist.isNotEmpty ? _songlist[_curIndex] : _emptySong;
  int get songsLen => _songlist.length;
  List<Song> get songList => _songlist;
  bool get isPlaying => _player.playing;
  int get playPosition => _player.position.inMilliseconds;

  playFromSong(Song song) async {
    if (song.url == "") {
      song = await MediaController.to.getSongUrl(song);
    }
    var item = _song2MediaItem(song);
    await _player
        .setAudioSource(AudioSource.uri(Uri.parse(song.url), tag: item));
    mediaItem.add(item);
    play();
  }

  setPlayMode(PlayMode mode) {
    _playMode=mode;
  }

  setSongChangeListener(listener) {
    _songChangeListener=listener;
  }

  _listenPlayEnd() {
    _player.playerStateStream.listen((state) {
      if (state.playing) {
      } else {}
      switch (state.processingState) {
        case ProcessingState.idle:
          break;
        case ProcessingState.loading:
          break;
        case ProcessingState.buffering:
          break;
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          skipToNext();
          break;
      }
    });
  }

  @override
  Future<void> changeQueueLists(List<Song> songs, {int index = 0}) async {
    _songlist.clear();
    _songlist.addAll(songs);
    _curIndex = index; // 更换了播放列表，将索引归0

    // notify system
    queue.value.clear();
    var mediaitems = songs.map((e) => _song2MediaItem(e));
    final newQueue = queue.value..addAll(mediaitems.toList());
    queue.add(newQueue);
    readySongUrl();
  }

  @override
  Future<void> playIndex(int index) async {
    _curIndex = index;
    readySongUrl();
  }

  @override
  Future<void> readySongUrl() async {
    var song = _songlist[_curIndex];
    if (song.url == "") {
      song = await MediaController.to.getSongUrl(song);
    }
    if(song.url == "") {
      DialogUtil.toast("${song.title}应该要花钱...");
    }
    var item = _song2MediaItem(song);
    try{
      await _player
          .setAudioSource(AudioSource.uri(Uri.parse(song.url), tag: item));
    }catch(e) {
      DialogUtil.toast("${song.title}好像播放不了...");
    }

    mediaItem.add(item);
    _songChangeListener(song);
    play();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if(_playMode==PlayMode.RANDOM) {
      _preIndex=_curIndex;
      var nextInt = Random.secure().nextInt(_songlist.length-1);
      _curIndex=nextInt;
    }else {
      if (_curIndex >= _songlist.length - 1) {
        _curIndex = 0;
      } else {
        _curIndex++;
      }
    }
    // 然后触发获取url
    readySongUrl();
    print('触发播放下一首');
  }

  @override
  Future<void> skipToPrevious() async {
    if(_playMode==PlayMode.RANDOM) {
      if(_curIndex==_preIndex) {
        _preIndex = Random.secure().nextInt(_songlist.length-1);
      }
      _curIndex=_preIndex;
    }else {
      if (_curIndex <= 0) {
        _curIndex = _songlist.length - 1;
      } else {
        _curIndex--;
      }
    }
    readySongUrl();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    _songlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    if (_songlist.isNotEmpty) {
      // 判断当前歌曲的位置是否是处于最后一位
      _songlist.insert(_curIndex + 1, _mediaItem2Song(mediaItem));
      final newQueue = queue.value..insert(_curIndex + 1, mediaItem);
      _curIndex++;
      queue.add(newQueue);
    } else {
      _songlist.insert(_curIndex, _mediaItem2Song(mediaItem));
      final newQueue = queue.value..insert(_curIndex, mediaItem);
      queue.add(newQueue);
    }
  }

  @override
  Future<void> play() async {
    _player.play();
  }

  @override
  Future<void> pause() async {
    print("handler pause");
    _player.pause();
  }

  MediaItem? getMediaItemFromQueue(String id) {
    return queue.value.firstWhere((element) => element.id == id);
  }

  MediaItem _song2MediaItem(Song song) {
    return MediaItem(
        id: song.id,
        title: song.title,
        artist: song.artist,
        album: song.album,
        duration: Duration(milliseconds: song.time),
        artUri: Uri.parse(song.imgUrl),
        extras: {
          "artistId": song.artistId,
          "sourceUrl": song.sourceUrl,
          "albumId": song.albumId,
          "source": song.source,
          "url": song.url,
          "disabled": song.disabled
        });
  }

  Song _mediaItem2Song(MediaItem item) {
    return Song(
        item.id,
        item.title,
        item.artist!,
        item.extras!["artistId"],
        item.album!,
        item.extras!["albumId"],
        item.extras!["sourceUrl"],
        item.extras!["source"],
        item.artUri.toString(),
        item.duration!.inMilliseconds,
        item.extras!["url"],
        item.extras!["disabled"]);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  @override
  Future<void> addSong(Song song) async {
    if (_songlist.isNotEmpty) {
      // 判断当前歌曲的位置是否是处于最后一位
      _songlist.insert(_curIndex + 1, song);
      final newQueue = queue.value
        ..insert(_curIndex + 1, _song2MediaItem(song));
      _curIndex++;
      queue.add(newQueue);
    } else {
      _songlist.insert(_curIndex, song);
      final newQueue = queue.value..insert(_curIndex, _song2MediaItem(song));
      queue.add(newQueue);
    }
  }
}
