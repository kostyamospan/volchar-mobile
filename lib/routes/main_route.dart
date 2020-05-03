import 'package:deplom/models/user.dart';
import 'package:deplom/routes/message_page_main_route.dart';
import 'package:deplom/routes/profile_owner_page.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'home_page_main_route.dart';
import 'search_page_main_route.dart';

class MainRoute extends StatefulWidget {
  MainRoute({Key key}) : super(key: key);

  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  List<Widget> _routes = [SearchPage(), HomePage(), MessagePage()];
  int _currentMenuPosition = 1;
  String imageUrl = "";

  int get currentMenuPosition => _currentMenuPosition;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        imageUrl = imageUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 100),
                      type: PageTransitionType.rightToLeft,
                      child: ProfilePageOwner(
                          (await StorageManager.isUserExist())?.username)));
            },
            child: Container(
              child: Row(children: [
                Center(
                    child: FutureBuilder(
                  future: new Future<User>(() => StorageManager.isUserExist()),
                  builder: (builder, snapshot) {
                    imageUrl =
                        (snapshot.data as User).profileImagePathWidthDomain;

                    return Text(snapshot?.data?.username,
                        style: TextStyle(fontSize: 20, color: Colors.white));
                  },
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15.0),
                  child: CircleAvatar(
                    radius: 18,
                    child: ClipOval(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 36,
                        width: 36,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      body: _routes[_currentMenuPosition],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentMenuPosition = index;
            print(_routes[_currentMenuPosition]);
          });
        },
        currentIndex: _currentMenuPosition,
        backgroundColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Colors.white,
            ),
            title: SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
