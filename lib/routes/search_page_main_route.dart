import 'package:deplom/header.dart';
import 'package:deplom/query_api.dart';
import 'package:deplom/routes/profile_page.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:deplom/widgets/user_preview.dart';
import 'package:page_transition/page_transition.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key) {
    shownList = List();
  }

  List<UserPreview> shownList;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String t = "";

  void callback(List<UserPreview> list, String t) {
    setState(() {
      print(t);
      this.t = t;
      widget.shownList = new List.from(list);
    });
  }

  Future loadUsersFromServer(String username) async {
    var res = await QueryApi.searchUser(
        (await StorageManager.isUserExist()).apiToken, username);

    setState(() {
      if (res == null) {
        widget.shownList = new List.generate(
            1,
            (index) => new UserPreview(
                  username: "nothing found",
                  imagePath: "",
                ));
      } else {
        widget.shownList = new List.generate(res.length, (i) {
          String username = res[i].username;
          return new UserPreview(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: ProfilePage(username),
                      type: PageTransitionType.rightToLeft));
            },
            username: username,
            imagePath: res[i].profileImagePathWidthDomain,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FutureBuilder(
            future:
                isListEmpty(widget.shownList) ? loadUsersFromServer(t) : null,
            builder: (context, snapshot) {
              if (isListEmpty(widget.shownList))
                return ListView(padding: EdgeInsets.only(top: 70), children: [
                  Center(
                      child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Text("Nothing found")))
                ]);
              return ListView(
                padding: EdgeInsets.only(top: 70),
                children: List.generate(widget.shownList.length, (i) {
                  return Center(
                      child: Padding(
                          padding: EdgeInsets.all(2),
                          child: widget.shownList[i]));
                }),
              );
            }),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 10),
              //width: displayWidth(context),
              child: SearchField(callback: callback, list: widget.shownList)),
        ),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({@required this.callback, @required this.list, Key key})
      : super(key: key);

  final Function callback;
  final List<UserPreview> list;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      //padding: EdgeInsets.all(3),
      height: 50,
      width: displayWidth(context),
      child: Padding(
        padding: EdgeInsets.only(left:10,right: 10),
              child: TextField(
          decoration: InputDecoration(hintText: "search"),
          onChanged: (t) {
            if (t != null && t != "") {
              if (t.length >= 3) {
                callback(search(list, t), t);
              } else {
                callback(list);
              }
            }
          },
        ),
      ),
    );
  }
}

List<UserPreview> search(List<UserPreview> list, String str) {
  return List.generate(list.length, (i) {
    if (list[i].username.contains(str)) return list[i];
  });
}

bool isListEmpty(List list) {
  int emptyCount = 0;
  for (var i = 0; i < list.length; i++) if (list[i] == null) emptyCount++;
  return emptyCount == list.length;
}
