import 'dart:convert';

class Message {
  String sender;
  String receiver;
  DateTime time;
  String data;

  Message({
    this.sender,
    this.receiver,
    this.time,
    this.data,
  });


  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'time': time.millisecondsSinceEpoch,
      'data': data,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Message(
      sender: map['sender'],
      receiver: map['receiver'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  static Message fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(sender: $sender, receiver: $receiver, time: $time, data: $data)';
  }
}

