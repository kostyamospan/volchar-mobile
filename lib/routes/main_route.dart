import 'package:deplom/routes/message_page_main_route.dart';
import 'package:flutter/material.dart';
import 'home_page_main_route.dart';


class MainRoute extends StatefulWidget {
  MainRoute({Key key}) : super(key: key);

  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  List<Widget> _routes = [
    Text("search page"),
    HomePage(),
    MessagePage()
  ];
  int _currentMenuPosition = 1;
  int get currentMenuPosition => _currentMenuPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(),
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
