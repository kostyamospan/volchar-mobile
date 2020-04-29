import 'package:flutter/material.dart';
import '../widgets/dialog_preview.dart';
import '../models/dialog_preview.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List<Widget>.generate(10, (index) {
      return DialogPreview(
          data: new DialogPrev(
              imageUrl:
                  "https://cs11.pikabu.ru/post_img/2019/02/04/12/1549312329147951618.jpg",
              time: DateTime.now(),
              username: "Unknown",
              lastMessage: "Some message"));
    }));
  }
}
