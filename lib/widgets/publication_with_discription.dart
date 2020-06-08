import 'package:deplom/query_api.dart';
import 'package:deplom/storage_manager.dart';
import 'package:deplom/widgets/publication.dart';
import 'package:flutter/material.dart';
import 'package:deplom/header.dart';
import 'package:deplom/models/publication.dart';
import 'package:like_button/like_button.dart';
import 'package:deplom/date_time_extensions.dart';


class PublicationExtended extends StatefulWidget {
  // final Widget child;
  final Publication _model;
  final Function callBack;
  Publication get model => _model;

  PublicationExtended(this._model, this.callBack, {Key key}) : super(key: key);

  @override
  _PublicationExtendedState createState() => _PublicationExtendedState();
}

class _PublicationExtendedState extends State<PublicationExtended> {
  Future<bool> onTap(bool isLiked) async {
    if (isLiked) {
      var oldValLiked = widget.model.isLiked;
      var oldLikesCount = widget.model.likesCount;

      setState(() {
        widget.model.isLiked = false;
        if (widget.model.likesCount >= 0) widget.model.likesCount--;
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
        } else {
          widget.callBack(widget.model.likesCount, widget.model.isLiked);
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
        } else {
          widget.callBack(widget.model.likesCount, widget.model.isLiked);
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
                      widget._model.creator.username,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                    },
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: displayWidth(context),
                    width: displayWidth(context),
                    child: Image.network(
                      widget._model.imagePathWithDomain,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null)
                          return FittedBox(fit: BoxFit.cover, child: child);

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(
                                text: widget._model.creator.username + ": ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: widget._model.description)
                          ]),
                    ),
                  )
                ],
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
                                isLiked: widget._model.isLiked,
                                mainAxisAlignment: MainAxisAlignment.start,
                                bubblesSize: 0,
                                likeCount: widget._model.likesCount,
                                onTap: onTap)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget._model.date.toFormatedDate(),
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
