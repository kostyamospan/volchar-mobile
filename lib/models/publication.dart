import 'dart:convert';
import 'package:deplom/header.dart';
import 'package:deplom/models/user.dart';

class Publication {
  String description = "";
  int likesCount;
  DateTime date;
  String imagePath;
  User creator;
  bool isLiked = false;
  String imagePathWithDomain;

  Publication(
      {this.description,
      this.likesCount = 0,
      DateTime date,
      this.imagePath,
      User creator,
      this.isLiked,
      String imagePathWithDomain})
      : this.date = date ?? DateTime.now(),
        this.creator = creator ?? new User(),
        this.imagePathWithDomain = (imagePathWithDomain == null
            ? fullDomen + imagePath
            : imagePathWithDomain);

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'likesCount': likesCount,
      'date': date.millisecondsSinceEpoch,
      'imageUrl': imagePath,
      'creator': creator.toMap(),
      'isLiked': isLiked
    };
  }

  static Publication fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Publication(
        description: map['Description'],
        likesCount: map['LikesCount'],
        date: DateTime.parse(map['Date']),
        imagePath: map['ImagePath'],
        creator: User.fromMap(map['Creator']),
        isLiked: map['IsLiked']);
  }

  String toJson() => json.encode(toMap());

  static Publication fromJson(String source) => fromMap(json.decode(source));

  String toFormatDate() =>
      "${date.day < 10 ? '0' + date.day.toString() : date.day.toString()}." +
      "${date.month < 10 ? '0' + date.month.toString() : date.month.toString()}." +
      "${date.year}";
}
