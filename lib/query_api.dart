import 'package:deplom/models/publication.dart';

import './models/user.dart';
import './models/publication.dart';
import './header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QueryApi {
  static Future<bool> userIsValid(User user) async {
    http.Response response = await http.post("$apiURL/app/isUserValid",
        body: jsonEncode(user.toMap()),
        headers: {'Content-type': 'application/json'});

    print(response.body);
    bool rez = response.body == "true" ? true : false;
    return rez;
  }

  static Future<User> logIn(User user) async {
    try {
      http.Response response = await http.post("$apiURL/app/login",
          body: jsonEncode(user.toMap()),
          headers: {'Content-type': 'application/json'});
      return response.body != "null"
          ? new User.fromMap(jsonDecode(response.body))
          : null;
    } catch (FormatException) {
      return null;
    }
  }

  static Future<List<Publication>> getAllUsersPublications(
      String apiToken, String username) async {
    try {
      http.Response response = await http.post(
          "$apiURL/app/getAllUsersPublications",
          body: jsonEncode({'apiToken': apiToken, 'username': username}),
          headers: {'Content-type': 'application/json'});

      List rez =
          response.body != "null" ? List.from(jsonDecode(response.body)) : null;
      print(rez);
      List<Publication> list = [];

      for (var item in rez) {
        list.add(Publication.fromMap(item));
      }
      print(list);
      return new Future(() => list);
    } catch (FormatException) {
      return Future.error(null);
    }
  }

  static Future<User> getUserData(String username) async {
    try {
      http.Response response = await http.post("$apiURL/app/getUserData",
          body: jsonEncode(username),
          headers: {'Content-type': 'application/json'});

      User rez = response.body != "null"
          ? User.fromMap(jsonDecode(response.body))
          : null;
      print(rez);

      return new Future(() => rez);
    } catch (FormatException) {
      return Future.error(null);
    }
  }

  static Future<bool> addLike(String apiToken, String imagePath) async {
    try {
      http.Response response = await http.post("$apiURL/app/addLike",
          body: jsonEncode({'apiToken': apiToken, 'imagePath': imagePath}),
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (Exception) {
      return false;
    }
  }

  static Future<bool> removeLike(String apiToken, String imagePath) async {
    try {
      http.Response response = await http.post("$apiURL/app/removeLike",
          body: jsonEncode({'apiToken': apiToken, 'imagePath': imagePath}),
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (Exception) {
      return false;
    }
  }
}
