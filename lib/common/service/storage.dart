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
  late Database _playlistDb;
  late StoreRef _playlistStore;

  Future<StorageService> init() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    // _factory = databaseFactoryIo;
    _db = await databaseFactoryIo.openDatabase(join(dir.path, "song.db"));
    _store = intMapStoreFactory.store("song");
    _playlistDb = await databaseFactoryIo.openDatabase(join(dir.path, "playlist.db"));
    _playlistStore = intMapStoreFactory.store("playlist");
    return this;
  }

  savePlaylist(Playlist playlist) async {
    await _playlistStore.add(_playlistDb, playlist.toJson());
  }

  Future<List<Playlist>> getPlaylists() async{
    var list = await _playlistStore.find(_playlistDb);

    return list.map((e) => Playlist.fromJson(e.value)).toList();
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
