import 'package:dio_log/dio_log.dart';
import 'package:get/get.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:unknown/common/model/playlist.dart';
import 'package:unknown/common/model/song.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late Database _db;
  late StoreRef _store;
  //本地歌单
  late Database _playlistDb;
  late StoreRef _playlistStore;
  //本地歌曲列表，关联歌单
  late Database _songsDb;
  late StoreRef _songsStore;

  Future<StorageService> init() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    // _factory = databaseFactoryIo;
    _db = await databaseFactoryIo.openDatabase(join(dir.path, "song.db"));
    _store = intMapStoreFactory.store("song");
    _playlistDb =
        await databaseFactoryIo.openDatabase(join(dir.path, "playlist.db"));
    _playlistStore = intMapStoreFactory.store("playlist");
    _songsDb = await databaseFactoryIo.openDatabase(join(dir.path, "songs.db"));
    _songsStore = intMapStoreFactory.store("songs");
    return this;
  }

  savePlaylist(Playlist playlist) async {
    await _playlistStore.add(_playlistDb, playlist.toJson());
  }

  deletePlaylist(String id) async {
    await _playlistStore.delete(_playlistDb,
        finder: Finder(filter: Filter.equals("id", id)));
    await _songsStore.delete(_songsDb,
        finder: Finder(filter: Filter.equals("albumId", id)));
  }

  Future<List<Playlist>> getPlaylists() async {
    var list = await _playlistStore.find(_playlistDb);

    return list.map((e) => Playlist.fromJson(e.value)).toList();
  }

  saveToPlayList(Song song, String id) {
    song.albumId = id;
    _songsStore.add(_songsDb, song.toJson());
  }

  saveAllToPlaylist(List<Song> songs, String id) {
    var eles = songs.map((e) {
      e.albumId = id;
      return e.toJson();
    }).toList();
    _songsStore.addAll(_songsDb, eles);
  }

  deleteFromPlaylist(String songid, String playlistId) async {
    await _songsStore.delete(_songsDb,
        finder: Finder(
            filter: Filter.equals("albumId", playlistId) &
                Filter.equals("id", songid)));
  }

  Future<bool> checkExistSongInPlayList(
      String songId, String playlistId) async {
    var record = await _songsStore.findFirst(_songsDb,
        finder: Finder(
            filter: Filter.equals("id", songId) &
                Filter.equals("albumId", playlistId)));
    return record != null;
  }

  Future<List<Song>> getPlaylistSongs(String playlistId) async {
    var record = await _songsStore.find(_songsDb,
        finder: Finder(filter: Filter.equals("albumId", playlistId)));
    return record.map((e) => Song.fromJson(e.value)).toList();
  }

  saveSong(Song song) async {
    _store.add(_db, song.toJson());
  }

  Future<Song?> getSongById(String id) async {
    var record = await _store.findFirst(_db,
        finder: Finder(filter: Filter.equals("id", id)));
    if (record != null) {
      return Song.fromJson(record.value);
    }
    return null;
  }
}
