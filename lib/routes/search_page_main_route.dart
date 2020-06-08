import 'package:deplom/header.dart';
import 'package:deplom/query_api.dart';
import 'package:deplom/routes/profile_page.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:deplom/widgets/user_preview.dart';
import 'package:page_transition/page_transition.dart';
import 'package:deplom/routes/profile_owner_page.dart';

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

  Future onChange(String t) async {
    if (t != null && t != "") {
      if (t.length >= 3) {
        var res = await loadUsersFromServer(t);
        setState(() {
          widget.shownList = search(res, t);
        });
      }
    } else {
      setState(() {
        widget.shownList = new List();
      });
    }
  }

  Future<List<UserPreview>> loadUsersFromServer(String username) async {
    var res = await QueryApi.searchUser(
        (await StorageManager.isUserExist()).apiToken, username);

    if (res == null) {
      return null;
    } else {
      return new List.generate(res.length, (i) {
        String username = res[i].username;
        return new UserPreview(
          onTap: () async {
            var user = await StorageManager.isUserExist();
            Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 100),
                    child: user.username == username
                        ? ProfilePageOwner(user.username)
                        : ProfilePage(username),
                    type: PageTransitionType.rightToLeft));
          },
          username: username,
          imagePath: res[i].profileImagePathWidthDomain,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.only(top: 70),
          children: List.generate(widget.shownList.length, (i) {
            return Center(
                child: Padding(
                    padding: EdgeInsets.all(2), child: widget.shownList[i]));
          }),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 10),
              //width: displayWidth(context),
              child: SearchField(onChange: onChange)),
        ),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({@required this.onChange, Key key}) : super(key: key);

  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      //padding: EdgeInsets.all(3),
      height: 50,
      width: displayWidth(context),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextField(
            decoration: InputDecoration(hintText: "search"),
            onChanged: onChange),
      ),
    );
  }
}

List<UserPreview> search(List<UserPreview> list, String str) {
  return List.generate(list?.length ?? 0, (i) {
    if (list[i].username.contains(str)) return list[i];
  });
}

bool isListEmpty(List list) {
  if (list == null) return null;

  int emptyCount = 0;
  for (var i = 0; i < list.length; i++) if (list[i] == null) emptyCount++;
  return emptyCount == list.length;
}
