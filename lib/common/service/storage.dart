
import 'package:get/get.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:unknown/common/model/song.dart';

class StorageService extends GetxService {
  static StorageService get to=> Get.find();
  static const String VALUE_KEY="SONG";
  late Database _db;
  late DatabaseFactory _factory;
  late StoreRef _store;

  Future<StorageService> init() async{
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    // _factory = databaseFactoryIo;
    _db = await databaseFactoryIo.openDatabase(join(dir.path,"song.db"));
    _store = intMapStoreFactory.store("song");
    return this;
  }

  saveSong(Song song) async{
    _store.add(_db, song.toJson());
  }

  Future<Song?> getSongById(String id) async {
    var record = await _store.findFirst(_db,finder: Finder(
      filter: Filter.equals("id", id)
    ));
    if(record!=null) {
      return Song.fromJson(record.value);
    }
    return null;
  }

}