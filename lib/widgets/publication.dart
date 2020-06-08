import 'package:deplom/query_api.dart';
import 'package:deplom/routes/profile_owner_page.dart';
import 'package:deplom/routes/profile_page.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:deplom/header.dart';
import 'package:deplom/models/publication.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:deplom/date_time_extensions.dart';

class Wrappper {
  LikeButton value;

  Wrappper(this.value);
}

class PublicationCard extends StatefulWidget {
  final Widget child;
  final Publication model;

  PublicationCard(this.model, {Key key, this.child}) : super(key: key);

  @override
  PublicationCardState createState() {
    return PublicationCardState();
  }
}

class PublicationCardState extends State<PublicationCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  void callBack(int count, bool isLiked) {
    setState(() {
      widget.model.likesCount = count;
      widget.model.isLiked = isLiked;
    });
  }

  Future<bool> onTap(bool isLiked) async {
    if (isLiked) {
      var oldValLiked = widget.model.isLiked;
      var oldLikesCount = widget.model.likesCount;

      setState(() {
        widget.model.isLiked = false;
        if (widget.model.likesCount > 0) widget.model.likesCount--;
      });
      QueryApi.removeLike((await StorageManager.isUserExist())?.apiToken,
              widget.model.imagePath)
          .then((value) {
        if (!value) {
          setState(() {
            widget.model.isLiked = oldValLiked;
            widget.model.likesCount = oldLikesCount;
          });
          print("ERROOORR");
        }
        return false;
      }).catchError((err) {
        setState(() {
          widget.model.isLiked = oldValLiked;
          widget.model.likesCount = oldLikesCount;
        });
        print("EROORRRR");
      });

      return Future<bool>(() => !isLiked);
    } else {
      var oldValLiked = widget.model.isLiked;
      var oldLikesCount = widget.model.likesCount;

      setState(() {
        widget.model.isLiked = true;
        widget.model.likesCount++;
      });
      QueryApi.addLike((await StorageManager.isUserExist())?.apiToken,
              widget.model.imagePath)
          .then((value) {
        if (!value) {
          setState(() {
            widget.model.isLiked = oldValLiked;
            widget.model.likesCount = oldLikesCount;
          });
          print("ERROOORR");
        }
        return true;
      }).catchError((err) {
        setState(() {
          widget.model.isLiked = oldValLiked;
          widget.model.likesCount = oldLikesCount;
        });

        print("EROORRRR");
      });
    }

    return Future<bool>(() => widget.model.isLiked);
  }

  Future<bool> _deletePublication() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(child: new CircularProgressIndicator()),
    );
    var user = await StorageManager.isUserExist();
    var res =
        await QueryApi.deletePublication(user.apiToken, widget.model.imagePath);

    Navigator.of(context).pop();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Stack(
        children: [
          Column(children: [
            Container(
              height: 50,
              color: Colors.white,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          widget.model.creator.username,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          PageTransition trans;

                          String username =
                              (await StorageManager.isUserExist()).username;
                          if (widget.model.creator.username != username)
                            trans = PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: Duration(milliseconds: 100),
                                child:
                                    ProfilePage(widget.model.creator.username));
                          else
                            trans = PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: Duration(milliseconds: 100),
                                child: ProfilePageOwner(username));

                          Navigator.push(context, trans);
                        },
                      ),
                      GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Delete this publication?"),
                                content: Text("This action cannot be undone!"),
                                //actionsPadding: EdgeInsets.all(10),
                                elevation: 10,
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.blue),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.blue),
                                    ),
                                    onPressed: () async {
                                      var user =
                                          await StorageManager.isUserExist();
                                      await _deletePublication();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => user
                                                          .username !=
                                                      widget.model.creator
                                                          .username
                                                  ? ProfilePage(widget
                                                      .model.creator.username)
                                                  : ProfilePageOwner(
                                                      user.username)));
                                    },
                                  ),
                                ],
                              ),
                            );

                            //
                          },
                          child: Icon(
                            Icons.restore_from_trash,
                            color: Colors.black87,
                            size: 30,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: displayWidth(context),
              width: displayWidth(context),
              child: Image.network(
                widget.model.imagePathWithDomain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null)
                    return GestureDetector(
                        onTap: () {
                          toModal(context, widget.model, this.callBack);
                        },
                        child: FittedBox(fit: BoxFit.cover, child: child));

                  return Center(
                    child: Container(
                      width: 65,
                      height: 65,
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
                color: Colors.white,
                height: 50,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(left: 15),
                            child: LikeButton(
                                isLiked: widget.model.isLiked,
                                mainAxisAlignment: MainAxisAlignment.start,
                                bubblesSize: 0,
                                likeCount: widget.model.likesCount,
                                onTap: this.onTap)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.model.date.toFormatedDate(),
                                  style: TextStyle(color: Colors.grey),
                                )),
                          ),
                        )
                      ],
                    ))),
          ])
        ],
      ),
    );
  }
}

_deletePublication() {}
