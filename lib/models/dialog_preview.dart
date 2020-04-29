import 'dart:convert';

class DialogPrev {
  String username;
  String imageUrl;
  DateTime time;
  String lastMessage;

  DialogPrev({
    this.username,
    this.imageUrl,
    this.time,
    this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'imageUrl': imageUrl,
      'time': time.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  static DialogPrev fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DialogPrev(
      username: map['username'],
      imageUrl: map['imageUrl'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      lastMessage: map['lastMessage'],
    );
  }

  String toJson() => json.encode(toMap());
  static DialogPrev fromJson(String source) => fromMap(json.decode(source));
  @override
  String toString() {
    return 'DialogPrev(username: $username, imageUrl: $imageUrl, time: $time, lastMessage: $lastMessage)';
  }

  String toDifferenceTime(){
    Duration dif  = DateTime.now().difference(time);
    return dif.inHours > 0 && dif.inDays > 0 ? 
      (dif.inDays > 0 ? "${dif.inDays}d": "${dif.inHours}h")
      : "${dif.inMinutes}m";
  }
}
