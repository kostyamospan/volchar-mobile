import 'package:deplom/query_api.dart';
import 'package:deplom/routes/profile_page.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:deplom/header.dart';
import 'package:deplom/models/publication.dart';
import 'package:like_button/like_button.dart';
import 'package:page_transition/page_transition.dart';

class Wrappper {
  LikeButton value;

  Wrappper(this.value);
}

class PublicationCard extends StatefulWidget {
  final Widget child;
  Publication model;
  Wrappper likeButton;

  PublicationCard(this.model, {Key key, this.child}) : super(key: key) {
    likeButton = new Wrappper(LikeButton(
        isLiked: model.isLiked,
        mainAxisAlignment: MainAxisAlignment.start,
        bubblesSize: 0,
        likeCount: model.likesCount,
        onTap: (isLiked) async {
          if (isLiked) {
            bool rez = await QueryApi.removeLike(
                (await StorageManager.isUserExist())?.apiToken,
                model.imagePath);
            if (rez) {
              model.isLiked = false;
              model.likesCount--;
              return Future<bool>(() => !isLiked);
            }
          } else {
            bool rez = await QueryApi.addLike(
                (await StorageManager.isUserExist())?.apiToken,
                model.imagePath);
            if (rez) {
              model.isLiked = true;
              model.likesCount++;
              return Future<bool>(() => !isLiked);
            }
          }

          return Future<bool>(() => isLiked);
        }));
  }

  @override
  PublicationCardState createState() {
    return PublicationCardState();
  }
}

class PublicationCardState extends State<PublicationCard>
    with AutomaticKeepAliveClientMixin {
  //getLikeButton()=>
  @override
  bool get wantKeepAlive => true;

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
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    child: Text(
                      widget.model.creator.username,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade,duration: Duration(milliseconds: 100),child: ProfilePage(widget.model.creator.username)));
                    },
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
                          toModal(context, widget.model, this);
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
                            child: widget.likeButton.value),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: GestureDetector(
                            child: Icon(
                              Icons.comment,
                              color: Colors.grey,
                              size: 28,
                            ),
                            onTap: () {
                              toModal(context, widget.model, this);
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.model.toFormatDate(),
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

Future<bool> onLikeButtonTapped(bool isLiked) async {
  return !isLiked;
}
