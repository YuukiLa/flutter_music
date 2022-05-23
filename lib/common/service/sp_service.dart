import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpService extends GetxService {
  static SpService get to => Get.find();
  late final SharedPreferences _prefs;

  Future<SpService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setCookie(String source, String cookie) async {
    return await _prefs.setString("${source}_cookie", cookie);
  }

  Future<bool> removeCookie(String source) async {
    return await _prefs.remove("${source}_cookie");
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  int getInt(String key) {
    return _prefs.getInt(key) ?? 0;
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  List<String> getList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
}
