import 'package:deplom/header.dart';
import 'package:deplom/storage_manager.dart';
import 'package:flutter/material.dart';

class SettingsRoute extends StatefulWidget {
  SettingsRoute({Key key}) : super(key: key);

  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          SettingsEl(
            onTap: () async {
              await StorageManager.save("user", "null");
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (Route<dynamic> route) => false);
            },
            text: "Log Out",
          ),
        ],
      ),
    );
  }
}

class SettingsEl extends StatelessWidget {
  const SettingsEl({@required this.onTap, @required this.text, Key key})
      : super(key: key);
  final String text;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          color: Colors.grey,
          height: 100,
          width: displayWidth(context),
          child: Padding(padding: EdgeInsets.all(10), child: Text(text))),
    );
  }
}
