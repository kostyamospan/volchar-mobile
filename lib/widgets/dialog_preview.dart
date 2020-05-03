import 'package:deplom/models/dialog_preview.dart';
import 'package:deplom/widgets/medium_size_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:deplom/header.dart';

class DialogPreview extends StatefulWidget {
  DialogPreview({this.data, Key key}) : super(key: key);

  final DialogPrev data;

  @override
  _DialogPreviewState createState() => _DialogPreviewState();
}

class _DialogPreviewState extends State<DialogPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
      width: displayWidth(context),
      height: 70,
      child: Row(
        children: <Widget>[
          CircleAvatarMedium(
            imagePath: widget.data.imageUrl,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Align(
                        child: Text(
                          widget.data.username,
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
                            child: Text(widget.data.toDifferenceTime())),
                      ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Align(
                      child: Text(widget.data.lastMessage,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis),
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
