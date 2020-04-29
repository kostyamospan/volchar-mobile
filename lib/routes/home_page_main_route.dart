import 'package:deplom/query_api.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
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
          await QueryApi.getAllUsersPublications(user.apiToken, user.username);
      var rez = List<PublicationCard>.generate(apiRez.length, (i) {
        print(apiRez[i].imagePath);
        return new PublicationCard(apiRez[i]);
      });
      return rez;
      // Future(()=>List<PublicationCard>.generate(10, (i){
      //   return new PublicationCard(new Publication(creator: new User(username:"username"),imageUrl: "https://img4.goodfon.ru/wallpaper/nbig/3/a0/osen-derevia-pririoda.jpg"));
      // }));//rez);
    });
    // Future.delayed(
    //     Duration(seconds: 2),
    //     () => List<PublicationCard>.generate(0, (index) {
    //           return new PublicationCard(new Publication(
    //               creator: User(username: "_admin"),
    //               imageUrl:
    //                   "https://borodatiyvopros.com/wp-content/uploads/2020/01/TVr0lqwFGRg.jpg"));
    //         }));
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
                  if (snapshot.data != null) {
                    return ListView(
                        children: snapshot.data as List<PublicationCard>);
                  } else {
                    return Text("Error");
                  }
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
