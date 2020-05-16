import 'package:deplom/header.dart';
import 'package:deplom/routes/profile_update_route.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SettingsRoute extends StatefulWidget {
  SettingsRoute({Key key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: <Widget>[
          SettingsEl(
            onTap: () async {
              var user = await StorageManager.isUserExist();
              Navigator.push(
                  context,
                  PageTransition(
                      child: ProfileUpdateRoute(
                          Image.network(user?.profileImagePathWidthDomain ?? "").image,
                          user?.username),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 100)));
            },
            icon: Icon(Icons.account_circle),
            text: "Change user data",
          ),
          SettingsEl(
            onTap: () async {
              await StorageManager.save("user", "null");
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (Route<dynamic> route) => false);
            },
            text: "Log Out",
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}

class SettingsEl extends StatelessWidget {
  const SettingsEl(
      {@required this.onTap, @required this.text, @required this.icon, Key key})
      : super(key: key);
  final String text;
  final Function onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          width: displayWidth(context) * 0.5,
          child: Row(
            children: <Widget>[
              icon,
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 20),
              ),
            ],
          )),
    );
  }
}
