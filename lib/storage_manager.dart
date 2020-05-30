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
    try {
      String logedUser = await StorageManager.read("user");
      User rez =
          logedUser != "null" ? User.fromMap(jsonDecode(logedUser)) : null;
      return Future<User>(() => rez);
    } catch (Exception) {
      await _initState();
      return null;
    }
  }

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(user.toMap()));
  }

  static Future<void> _initState() async {
    await save("user", "null");
  }
}
