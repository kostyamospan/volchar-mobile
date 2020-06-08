import 'package:deplom/models/comment.dart';
import 'package:deplom/routes/profile_owner_page.dart';
import 'package:deplom/routes/profile_page.dart';
import 'package:deplom/storage_manager.dart';
import 'package:deplom/widgets/medium_size_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:deplom/header.dart';
import 'package:deplom/date_time_extensions.dart';
import 'package:page_transition/page_transition.dart';

class UserComment extends StatefulWidget {
  UserComment(this.data, {Key key}) : super(key: key);
  Comment data;
  @override
  _UserCommentState createState() => _UserCommentState();
}

class _UserCommentState extends State<UserComment> {
  void navigateToProfilePage() async {
    var username = (await StorageManager.isUserExist()).username;
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 100),
            child: widget.data.username == username
                ? ProfilePageOwner(widget.data.username)
                : ProfilePage(username),
            type: PageTransitionType.rightToLeft));
  }

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
            child: GestureDetector(
              onTap: navigateToProfilePage,
              child: CircleAvatarMedium(
                imagePath: widget.data.imagePathWithDomain,
              ),
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
                        child: GestureDetector(
                          onTap: navigateToProfilePage,
                          child: Text(
                            widget.data.username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(widget.data.time.toFormatedDate()),
                              )))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Align(
                      child: Text(widget.data.text,
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
