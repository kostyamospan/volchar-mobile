import 'package:deplom/models/publication.dart';
import 'package:deplom/widgets/publication_with_discription.dart';
import 'package:flutter/material.dart';

class PublicationFullInfo extends ModalRoute<void> {
  final Publication data;
  final Function callBack;

  PublicationFullInfo(this.data, this.callBack);
  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Color(0xfff5f5f5).withOpacity(1.0);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    
    return Material(
      type: MaterialType.transparency,
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          PublicationExtended(data, this.callBack),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
