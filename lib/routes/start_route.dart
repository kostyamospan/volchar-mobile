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

  Future<User> load() async {
    bool isSuccess = true;
    bool isAutorized = false;
    User user;
    try {
      user = await StorageManager.isUserExist();

      if (user == null) return user;
      //navigateToRoute(context, "/login");

      isAutorized = await QueryApi.userIsValid(user);
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
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: AutTemlate(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset('assets/untitled.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: FutureBuilder(
                      future: StorageManager.isUserExist(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Storage error");
                          //return Icon(Icons.cancel, color: Colors.red);
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return new CircularProgressIndicator();
                          case ConnectionState.done:
                            {
                              if (snapshot.data != null) {
                                return new FutureBuilder(
                                  future: QueryApi.userIsValid(snapshot.data),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      // return Icon(Icons.cancel,
                                      //     color: Colors.red);
                                      return Text("Connection error");
                                    }
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                      case ConnectionState.active:
                                        return new CircularProgressIndicator();
                                      case ConnectionState.done:
                                        {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (snapshot.data as bool) {
                                              navigateToRoute(context, "/main");
                                            } else {
                                              navigateToRoute(
                                                  context, "/login");
                                            }
                                          });
                                          return Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 20,
                                          );
                                        }
                                        break;
                                      default:
                                        return null;
                                    }
                                  },
                                );
                              } else {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  navigateToRoute(context, "/login");
                                });
                              }
                            }
                            break;
                          default:
                            return new SizedBox.shrink();
                        }
                        return new SizedBox.shrink();
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
