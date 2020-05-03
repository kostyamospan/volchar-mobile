import 'package:deplom/header.dart';
import 'package:deplom/query_api.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:deplom/widgets/user_preview.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key) {
    shownList = list;
  }

  final List<UserPreview> list = [
    new UserPreview(
        username: "username",
        imagePath:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg'),
    new UserPreview(
        username: "nika",
        imagePath:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg'),
    new UserPreview(
        username: "Tomes",
        imagePath:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg'),
    new UserPreview(
        username: "xiixxixix",
        imagePath:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg'),
    new UserPreview(
        username: "anton",
        imagePath:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg'),
  ];

  List<UserPreview> shownList;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void callback(List<UserPreview> list) {
    setState(() {
      widget.shownList = list;
    });
  }

  void drawList() {}
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(widget.shownList.length + 1, (i) {
        if (i == 0) {
          // if (widget.shownList.isEmpty) {
          //   searchList = await QueryApi.searchUsers(
          //       (await StorageManager.isUserExist()).apiToken);
          // }

          return Center(
            child: Container(
                padding: EdgeInsets.only(bottom: 10),
                width: displayWidth(context) * 0.95,
                child: SearchField(callback: callback, list: widget.list)),
          );
        }
        return Center(
            child: Padding(
                padding: EdgeInsets.all(2), child: widget.shownList[i - 1]));
      }),
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
      child: TextField(
        decoration: InputDecoration(hintText: "search"),
        onChanged: (t) {
          if (t != null && t != "") {
            if (t.length >= 3) {
              print(list);
              callback(search(list, t));
            }
          } else {
            print(list);
            callback(list);
          }
        },
      ),
    );
  }
}

List<UserPreview> search(List<UserPreview> list, String str) {
  return List.generate(list.length, (i) {
    if (list[i].username.contains(str)) return list[i];
  });
}
