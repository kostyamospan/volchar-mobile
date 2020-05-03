import 'package:flutter/material.dart';

class CircleAvatarMedium extends StatelessWidget {
  const CircleAvatarMedium({this.imagePath, Key key}) : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            margin: EdgeInsets.only(left: 5, right: 10),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(imagePath)),
            )));
  }
}
