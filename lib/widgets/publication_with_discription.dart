import 'package:deplom/query_api.dart';
import 'package:deplom/storage_manager.dart';
import 'package:deplom/widgets/publication.dart';
import 'package:flutter/material.dart';
import 'package:deplom/header.dart';
import 'package:deplom/models/publication.dart';
import 'package:like_button/like_button.dart';

class PublicationExtended extends StatefulWidget {
  final Widget child;
  final Publication _model;
  PublicationCardState card;
  Publication get model => _model;

  PublicationExtended(this._model,this.card, {Key key, this.child}) : super(key: key);

  @override
  _PublicationExtendedState createState() => _PublicationExtendedState();
}

class _PublicationExtendedState extends State<PublicationExtended> {
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
                      print("asdasd");
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
                      //textAlign: TextAlign.start,
                      text: TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(
                                text: widget._model.creator.username + ":",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    " asdasdasas dasdas dass dasdasdasda sdasda sddasd as dasdasd asdasdas ddasd")
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
                                onTap: (isLiked) async {
                                  if (isLiked) {
                                    bool rez = await QueryApi.removeLike(
                                        (await StorageManager.isUserExist())
                                            ?.apiToken,
                                        widget._model.imagePath);
                                    if (rez) {
                                      widget._model.isLiked = false;
                                      widget._model.likesCount--;
                                      return Future<bool>(() => !isLiked);
                                    }
                                  } else {
                                    bool rez = await QueryApi.addLike(
                                        (await StorageManager.isUserExist())
                                            ?.apiToken,
                                        widget._model.imagePath);
                                    if (rez) {
                                      widget._model.isLiked = true;
                                      widget._model.likesCount++;
                                      return Future<bool>(() => !isLiked);
                                    }
                                  }

                                  return Future<bool>(() => isLiked);
                                })),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: GestureDetector(
                            child: Icon(
                              Icons.comment,
                              color: Colors.grey,
                              size: 28,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget._model.toFormatDate(),
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

