import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../model/song.dart';

class UnknownAudioPlayerHandler extends BaseAudioHandler with SeekHandler,QueueHandler {
  final _player = AudioPlayer();

  UnknownAudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  playFromSong(Song song) async {
    var item = MediaItem(
      id: song.id,
      title: song.title,
      artist: song.artist,
      album: song.album,
      duration: const Duration(milliseconds: 1234567890),
      artUri: Uri.parse(song.imgUrl),
    );
    await _player.setAudioSource(AudioSource.uri(Uri.parse(song.url),tag: item));
    mediaItem.add(item);
    play();
  }

  @override
  Future<void> play() async{
    _player.play();
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async{
    await _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItem.id),tag: mediaItem));
    print("play media item");
    play();
  }


  @override
  Future<void> playFromMediaId(String mediaId,
      [Map<String, dynamic>? extras]) async{
    var item = getMediaItemFromQueue(mediaId);
    print(item);
    if(item!=null) {
      playMediaItem(item);
    }
  }

  MediaItem? getMediaItemFromQueue(String id) {
    return queue.value.firstWhere((element) => element.id==id);
  }

  @override
  Future<void> pause() async{
    print("handler pause");
    _player.pause();
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,

      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0,1, 3],
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
}