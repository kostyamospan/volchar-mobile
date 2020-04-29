import 'package:deplom/models/publication.dart';
import 'package:deplom/widgets/publication.dart';
import 'package:deplom/widgets/publication_with_discription.dart';
import 'package:flutter/material.dart';
import 'comment.dart'; 

class PublicationFullInfo extends ModalRoute<void> {

  final Publication data;
  PublicationCardState card;
  PublicationFullInfo(this.data,this.card);
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
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: _buildOverlayContent(context),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: ListView(children: <Widget>[
        PublicationExtended(data,card),
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Text("Comments: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        ),
        Comment(),
        Comment(),
        Comment(),
        Comment()
      ],),
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
