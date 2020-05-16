import 'package:deplom/models/publication.dart';

import './models/user.dart';
import './models/publication.dart';
import './header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:async/async.dart';

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
      return response.body != "null" && response.statusCode == 200
          ? new User.fromMap(jsonDecode(response.body))
          : null;
    } catch (FormatException) {
      return null;
    }
  }

  static Future<User> register(User user) async {
    try {
      http.Response response = await http.post("$apiURL/app/register",
          body: jsonEncode(user.toMap()),
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 502) return Future.error(new Exception());
      return response.body != "null" && response.statusCode == 200
          ? new User.fromMap(jsonDecode(response.body))
          : null;
    } catch (FormatException) {
      return Future.error(new Exception());
    }
  }

  static Future<List<Publication>> allUsersSubscribedPubl(
      String apiToken, String username) async {
    try {
      http.Response response = await http.post("$apiURL/app/allUsersSubscribes",
          body: jsonEncode({'apiToken': apiToken, 'username': username}),
          headers: {'Content-type': 'application/json'});

      List rez =
          response.body != "null" ? List.from(jsonDecode(response.body)) : null;
      print(rez);
      List<Publication> list = [];

      for (var item in rez) {
        list.add(Publication.fromMap(item));
      }
      return new Future(() => list);
    } catch (FormatException) {
      return Future.error(new Exception());
    }
  }

  static Future<User> getUserData(String username, String usernameOwner) async {
    try {
      http.Response response = await http.post("$apiURL/app/getUserData",
          body: jsonEncode(
              {'username': username, 'usernameOwner': usernameOwner}),
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

  static Future<bool> subscribe(String apiToken, String username) async {
    try {
      http.Response response = await http.post("$apiURL/app/subscribe",
          body: jsonEncode({'apiToken': apiToken, 'username': username}),
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (Exception) {
      return false;
    }
  }

  static Future<bool> unSubscribe(String apiToken, String username) async {
    try {
      http.Response response = await http.post("$apiURL/app/unSubscribe",
          body: jsonEncode({'apiToken': apiToken, 'username': username}),
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (Exception) {
      return false;
    }
  }

  static Future<List<User>> getUsersSubscribes(String apiToken) async {
    try {
      http.Response response = await http.post("$apiURL/app/getUserSubscribes",
          body: jsonEncode({'apiToken': apiToken}),
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 200) {
        List rez = response.body != "null"
            ? List.from(jsonDecode(response.body))
            : null;

        List<User> list = [];

        for (var item in rez) {
          list.add(User.fromMap(item));
        }
        return list;
      } else
        return Future.error(new Exception());
    } catch (Exception) {
      return Future.error(null);
    }
  }

  static Future<List<User>> searchUser(String apiToken, String username) async {
    try {
      http.Response response = await http.post("$apiURL/app/searchUser",
          body: jsonEncode({'apiToken': apiToken, 'username': username}),
          headers: {'Content-type': 'application/json'});

      if (response.statusCode == 200) {
        List rez = response.body != "null"
            ? List.from(jsonDecode(response.body))
            : null;
        print(rez);
        List<User> list = [];

        for (var item in rez) {
          list.add(User.fromMap(item));
        }
        return list;
      } else
        return Future.error(new Exception());
    } catch (Exception) {
      return Future.error(null);
    }
  }

  static Future<bool> upload(
      File imageFile, String apiToken, String description) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

    var length = await imageFile.length();

    var request = new http.MultipartRequest(
        "POST", Uri.parse("$apiURL/app/addPublication"));

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields["apiToken"] = apiToken;
    request.fields["description"] = description;

    var response = await request.send();

    return (response.statusCode == 200 ? true : false);
  }

  static Future<User> profileUpdate(String apiToken,
      {File updatedProfileFile, String updatedUsername}) async {
    try {
      var request = new http.MultipartRequest(
          "POST", Uri.parse("$apiURL/app/updateUserProfile"));

      if (updatedProfileFile != null) {
        var stream = new http.ByteStream(
            DelegatingStream.typed(updatedProfileFile.openRead()));

        var length = await updatedProfileFile.length();

        var multipartFile = new http.MultipartFile("file", stream, length,
            filename: basename(updatedProfileFile.path));
        request.files.add(multipartFile);
      }

      request.fields["apiToken"] = apiToken;

      if (updatedUsername != null) request.fields["username"] = updatedUsername;

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        return User.fromMap(jsonDecode(response.body));
      } else {
        return Future.error(new Exception());
      }
    } catch (Exception) {
      return null;
      //return Future.error(new Exception());
    }
  }
}
