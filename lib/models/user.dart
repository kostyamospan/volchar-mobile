import 'dart:convert';

import 'package:deplom/header.dart';
import 'package:deplom/models/publication.dart';

class User {
  String apiToken;

  String username;

  String password;

  String email;

  int publicationsCount;

  int subsctibersCount;

  List<Publication> publications;

  String profileImagePath;

  String profileImagePathWidthDomain;

  User({
    this.apiToken,
    this.username,
    this.password,
    this.email,
  });

  User.fromMap(Map<String, dynamic> json) {
    apiToken = json["ApiToken"];
    username = json["Username"];
    password = json["Password"];
    email = json["Email"];
    publicationsCount = json["PublicationsCount"];
    subsctibersCount = json["SubscribersCount"];
    profileImagePath = json["ProfileImage"];
    profileImagePathWidthDomain = profileImagePath == null? null :  fullDomen + profileImagePath;

    List<Map<String, dynamic>> rez =
        json["Publications"] != "null" && json.containsKey("Publications")
            ? List<Map<String, dynamic>>.from(json["Publications"])
            : null;
    if (rez != null) {
      List<Publication> list = [];

      for (var item in rez) {
        list.add(Publication.fromMap(item));
      }

      publications = list;
    }
  }

  Map<String, String> toMap() => {
        'ApiToken': apiToken,
        'Username': username,
        'Password': password,
        'Email': email,
        'Publications': jsonEncode(publications)
      };
}
