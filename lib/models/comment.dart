import 'dart:convert';

import 'package:deplom/header.dart';
import 'package:flutter/material.dart';

class Comment {
  String username;
  String text;
  DateTime time;
  String imagePath;
  String imagePathWithDomain;

  Comment([
    this.username,
    this.text,
    this.time,
    this.imagePath,
    this.imagePathWithDomain,
  ]);

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'text': text,
      'time': time?.millisecondsSinceEpoch,
      'imagePath': imagePath,
    };
  }

  static Comment fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Comment(
      map['username'],
      map['text'],
      DateTime.parse(map['time']),
      map['imagePath'],
      fullDomen + map['imagePath']
    );
  }

  String toJson() => json.encode(toMap());

  static Comment fromJson(String source) => fromMap(json.decode(source));
}
