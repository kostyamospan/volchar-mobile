import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/autorization_template.dart';
import '../query_api.dart';
import '../storage_manager.dart';
import '../models/user.dart';
import '../header.dart';



class StartRoute extends StatefulWidget {
  StartRoute({Key key}) : super(key: key);

  @override
  _StartRouteState createState() => _StartRouteState();
}

class _StartRouteState extends State<StartRoute> {
  Widget _widget = new CircularProgressIndicator();

  void onLoad() async {
    bool isSuccess = true;
    bool isAutorized = false;
    User user;
    try {
       user = await StorageManager.isUserExist();

      if (user == null) {
        navigateToRoute(context, "/login");
        return;
      }

      isAutorized = await QueryApi.userIsValid(user);
      print(isAutorized);
    } catch (Exception) {
      isSuccess = false;
    }
    if (isSuccess) {
      if (isAutorized) {
      await StorageManager.save("user", jsonEncode(user.toMap()));
        navigateToRoute(context, "/main");
      } else {
        navigateToRoute(context, "/login");
      }
    } else {
      setStateIcon(Icons.remove_circle_outline, Colors.red);
      Future.delayed(const Duration(seconds: 5), () => onLoad());
    }
  }

  void setStateIcon(IconData icon, Color color) {}

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.onLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("hii")),
        body: AutTemlate(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  height: 300,
                  child: SvgPicture.asset('assets/untitled.svg'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _widget,
                ),
              ],
            ),
          ),
        ));
  }
}

