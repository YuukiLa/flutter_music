import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:unknown/common/service/media_service.dart';

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
  int _curIndex = 0;
  UnknownAudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  Song get currPlaying =>
      _songlist.isNotEmpty ? _songlist[_curIndex] : _emptySong;
  int get songsLen => _songlist.length;
  List<Song> get songList => _songlist;
  bool get isPlaying => _player.playing;

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
  }

  @override
  Future<void> playIndex(int index) async {
    _curIndex = index;
    readySongUrl();
  }

  @override
  Future<void> readySongUrl() async {
    var song = this._songlist[_curIndex];
    if (song.url == "") {
      song = await MediaController.to.getSongUrl(song);
    }
    var item = _song2MediaItem(song);
    await _player
        .setAudioSource(AudioSource.uri(Uri.parse(song.url), tag: item));
    mediaItem.add(item);
    play();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async {
    // 当触发播放下一首
    if (_curIndex >= _songlist.length - 1) {
      _curIndex = 0;
    } else {
      _curIndex++;
    }
    // 然后触发获取url
    readySongUrl();
    print('触发播放下一首');
  }

  @override
  Future<void> skipToPrevious() async {
    if (_curIndex <= 0) {
      _curIndex = _songlist.length - 1;
    } else {
      _curIndex--;
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
    if (_songlist.length > 0) {
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
    if (_songlist.length > 0) {
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
