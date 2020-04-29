import 'package:flutter/material.dart';

class AutTemlate extends StatelessWidget {
  final Widget child;

  AutTemlate({
    this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        child: child,
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Text(
          "©copyright  2020",
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 15, color: Color(0xFF929292)),
        ),
      ),
    ]);
  }
}