import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  SharedPreferences? _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> write(String key, dynamic value) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs!.setStringList(key, value);
    } else {
      await _prefs!.setString(key, jsonEncode(value));
    }
  }

  dynamic read(String key) {
    if (_prefs == null) return null;
    return _prefs!.get(key);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> remove(String key) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    await _prefs!.remove(key);
  }

  Future<void> clearAll() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    await _prefs!.clear();
  }
}
