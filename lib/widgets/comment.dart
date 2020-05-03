import 'package:deplom/widgets/medium_size_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:deplom/header.dart';

class Comment extends StatefulWidget {
  Comment({Key key}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
      width: displayWidth(context),
      //height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CircleAvatarMedium(
              imagePath:
                  'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg',
            ),
          ),
          //
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Align(
                        child: Text(
                          "username",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("asdasd")),
                      ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Align(
                      child: Text(
                          "asdasdASDASDASDASDASDASasdasdASDASDASDASDASDASDASDSDASDASDASDASDASDASDASDADasdDASDSDASDASDASDASDASDASDASDADasd",
                          style: TextStyle(fontSize: 15)),
                      alignment: Alignment.centerLeft,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
