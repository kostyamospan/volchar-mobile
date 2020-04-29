import 'dart:convert';
import 'package:flutter/material.dart';
import '../header.dart';
import '../widgets/autorization_template.dart';
import '../routes/register_route.dart';
import '../models/user.dart';
import '../storage_manager.dart';
import '../header.dart';
import '../query_api.dart';

class LoginRoute extends StatefulWidget {
  LoginRoute({Key key}) : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final _formKey = GlobalKey<FormState>();

  String _mail;
  String _password;

  bool _isButtonClicked = false;

  Future<User> logIn() async {
    User user = new User(email: _mail, password: _password);
    User logedUser = await QueryApi.logIn(user);
    if(logedUser != null) StorageManager.save("user", jsonEncode(logedUser.toMap()));
    else return Future.error(null);

    return Future<User>(() => logedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("app"),
      ),
      body: AutTemlate(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
              SizedBox(
                width: displayWidth(context) * 0.8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(hintText: "Enter Email"),
                        validator: (input) {
                          if(input!=null)
                            _mail = input;
                          // if (emailReg.hasMatch(input)) {
                          //   
                          //   return null;
                          // } else if (input == null) {
                          //   return reqError;
                          // } else {
                          //   return "Your email isnt valid";
                          // }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            fillColor: Colors.black,
                            contentPadding: EdgeInsets.all(0),
                            hintText: "Enter Password"),
                        validator: (input) {
                          if (input != null) {
                            _password = input;
                            return null;
                          } else {
                            return reqError;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 40,
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        child: FlatButton(
                          child: FutureBuilder<User>(
                            builder: (context, snapshot) {
                              
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  return CircularProgressIndicator();
                                case ConnectionState.none:
                                  return Text(
                                    "Login",
                                    textAlign: TextAlign.center,
                                  );
                                case ConnectionState.done:
                                  if (snapshot.data == null) {
                                    return Text("try again");
                                  } else {
                                    print(snapshot.data);                             
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) =>
                                            navigateToRoute(context, "/main"));
                                  }
                                  return SizedBox.shrink();
                              }
                            },
                            future: _isButtonClicked ? logIn() : null,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_formKey.currentState.validate()) {
                                _isButtonClicked = true;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterRoute()),
                    );
                  },
                  child: Text(
                    "Doesn`t have an account yet? Tap here",
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
