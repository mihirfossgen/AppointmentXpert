import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static SharedPreferences? _prefsInstance;
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();

  static saveStr(String key, String message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, message);
  }

  clearAllData() {
    _prefsInstance?.clear();
  }

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static String readPrefStr(String key) {
    String value;
    value = _prefsInstance?.getString(key) ?? "";
    return value;
  }

  static saveBool(String key, bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  static readPrefBool(String key) async {
    bool value;
    value = _prefsInstance?.getBool(key) ?? false;
    return value;
  }

  static saveInt(String key, int value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  static int readPrefINt(String key) {
    int value;
    value = _prefsInstance?.getInt(key) ?? 0;
    return value;
  }

  static saveDouble(String key, double value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(key, value);
  }

  static readPrefDouble(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble(key);
  }

  static clearPreferences() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
