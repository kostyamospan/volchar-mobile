import 'package:deplom/query_api.dart';
import 'package:deplom/routes/upload_route.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../widgets/publication.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  Future<List<PublicationCard>> loadPublications() async {
    return Future(() async {
      User user = await StorageManager.isUserExist();
      var apiRez =
          await QueryApi.allUsersSubscribedPubl(user.apiToken, user.username);
      var rez = List<PublicationCard>.generate(apiRez.length, (i) {
        print(apiRez[i].imagePath);
        return new PublicationCard(apiRez[i]);
      });
      return rez;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      child: FutureBuilder(
          future: loadPublications(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
                break;
              case ConnectionState.done:
                {
                  Widget content = Text("Error");
                  if (snapshot.data != null &&
                      (snapshot.data as List).length != 0) {
                    content = ListView(
                        children: snapshot.data as List<PublicationCard>);
                  } else {
                    content =
                        Center(child: Text("Nothing in yours feed yet ;)"));
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return Future(() => null);
                    },
                    child: Stack(
                      children: [
                        content,
                        Positioned(
                          bottom: 15,
                          right: 15,
                          child: FloatingActionButton(
                            splashColor: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 100),
                                      type: PageTransitionType.rightToLeft,
                                      child: UploadRoute()));
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach the bottom");
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach the top");
    }
  }
}
