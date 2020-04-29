import 'package:flutter/material.dart';
import '../widgets/autorization_template.dart';
import '../header.dart';

class RegisterRoute extends StatefulWidget {
  RegisterRoute({Key key}) : super(key: key);

  @override
  _RegisterRouteState createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final _formKey = GlobalKey<FormState>();

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
                "Register",
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
                        decoration: InputDecoration(hintText: "Enter login"),
                        validator: (input) {
                          if (loginReg.hasMatch(input) && input.length >= 6)
                            return null;
                          else if (input.isEmpty)
                            return reqError;
                          else
                            return "Your name isnt valid";
                        },
                      ), //Login Field
                    
                      TextFormField(
                        decoration: InputDecoration(hintText: "Enter Email"),
                        validator: (input) {
                          if (emailReg.hasMatch(input))
                            return null;
                          else if (input.isEmpty)
                            return reqError;
                          else
                            return "Your email isnt valid";
                        },
                      ), //Email Field
                      TextFormField(
                        decoration: InputDecoration(hintText: "Enter Password"),
                        validator: (input) {
                          if (input.isEmpty)
                            return reqError;
                          else if (pasReg.hasMatch(input))
                            return null;
                          else
                            return passError;
                        },
                      ), //Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 40,
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        child: FlatButton(
                          child: Text(
                            "Register",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/login',
                    );
                  },
                  child: Text(
                    "Already have an account yet? Tap here",
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
