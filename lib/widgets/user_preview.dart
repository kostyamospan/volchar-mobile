import 'package:deplom/header.dart';
import 'package:deplom/widgets/medium_size_circle_avatar.dart';
import 'package:flutter/material.dart';

class UserPreview extends StatelessWidget {
  const UserPreview({this.username = "", this.imagePath = "", Key key})
      : super(key: key);
  final String username;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: displayWidth(context) * 0.9,
        child: Row(
          children: <Widget>[
            CircleAvatarMedium(
              imagePath: imagePath,
            ),
            Text(
              username,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
