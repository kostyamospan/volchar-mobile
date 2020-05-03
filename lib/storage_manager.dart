import 'package:shared_preferences/shared_preferences.dart';
import './models/user.dart';
import 'dart:convert';

class StorageManager {
  static Future save(final String key, final String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> read(final String key) async {
    final prefs = await SharedPreferences.getInstance();
    return new Future<String>(() => prefs.getString(key));
  }

  static Future<User> isUserExist() async {
    String logedUser = await StorageManager.read("user");
    print(logedUser);
    User rez = logedUser != "null" ? User.fromMap(jsonDecode(logedUser)) : null;
    return Future<User>(() => rez);
  }
}
