import 'dart:convert';

import 'package:deplom/header.dart';
import 'package:deplom/models/publication.dart';
import 'package:deplom/query_api.dart';
import 'package:deplom/storage_manager.dart';
import 'package:deplom/widgets/comment.dart';
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
    return _FullModalContent(data, callBack);
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

class _FullModalContent extends StatefulWidget {
  _FullModalContent(this.data, this.callBack, {Key key}) : super(key: key);
  Function callBack;
  final Publication data;
  @override
  _FullModalContentState createState() => _FullModalContentState();
}

class _FullModalContentState extends State<_FullModalContent> {
  final TextEditingController _textEditingController;
  List<UserComment> _comments;

  bool _isSubmited = false;
  bool _isCommentsLoaded = false;

  _FullModalContentState({Key key})
      : _textEditingController = new TextEditingController();

  Future<Widget> loadComments() async {
    var user = await StorageManager.isUserExist();
    List<UserComment> res = await QueryApi.getPublicationComments(
        user.apiToken, widget.data.imagePath);
    if (res != null) {
      _comments = res;
      return Column(
        children: _comments,
      );
    } else {
      return Future.error(new Exception());
    }
  }

  Future<UserComment> leaveComment(String comment) async {
    if (comment == "" && comment != null) return null;
    var user = await StorageManager.isUserExist();
    var com = await QueryApi.leaveComment(
        user.apiToken, widget.data.imagePath, comment);

    if (com != null) {
      return com;
    } else {
      return Future.error(new Exception());
    }
  }

  void onCommentLeave(UserComment data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (_comments != null) {
          if (_comments.length == 0)
            _comments.add(data);
          else
            _comments.insert(_comments.length - 1, data);
        } else
          _comments = [data];
        _resetTextField();
      });
    });
  }

  void _resetTextField() {
    setState(() {
      _isSubmited = false;
      var text = _textEditingController.value.text;
      _textEditingController.value = new TextEditingValue(text: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          PublicationExtended(widget.data, widget.callBack),
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Container(
                      child: TextField(
                        controller: _textEditingController,
                        onSubmitted: (str) {
                          if (str == "" && str == null) return;

                          setState(() {
                            _isSubmited = true;
                          });
                        },
                        decoration:
                            InputDecoration(hintText: "Comment here..."),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: _isSubmited
                            ? leaveComment(
                                _textEditingController.value.text ?? "")
                            : null,
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Icon(Icons.error, color: Colors.red);
                          switch (snapshot.connectionState) {
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return CircularProgressIndicator();

                            case ConnectionState.none:
                              return IconButton(
                                onPressed: () {
                                  if (_textEditingController.value.text == "" &&
                                      _textEditingController.value.text == null)
                                    return;
                                  setState(() {
                                    _isSubmited = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.blue,
                                  size: 40,
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                onCommentLeave(snapshot.data);
                              }
                              break;
                          }
                          return IconButton(
                            onPressed: () {
                              if (_textEditingController.value.text == "" &&
                                  _textEditingController.value.text == null)
                                return;
                              setState(() {
                                _isSubmited = true;
                              });
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.blue,
                              size: 40,
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: loadComments(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Column(
                    children: _comments ?? [],
                  );
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    _isCommentsLoaded = true;
                    return snapshot.data as Widget;
                  }
                  if (snapshot.hasError)
                    return Icon(Icons.error, color: Colors.red);
              }

              return Column(
                children: _comments ?? [],
              );
            },
          )
        ],
      ),
    );
  }
}
