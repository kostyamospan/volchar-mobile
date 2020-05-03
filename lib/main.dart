import 'package:deplom/routes/login_route.dart';
import 'package:deplom/routes/register_route.dart';
import 'package:flutter/material.dart';
import './routes/start_route.dart';
import './routes/main_route.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Theme(
              data: ThemeData(primaryColor: Color(0xff1B98E0)),
              child:  StartRoute()),
        ),
        routes:{
          "/main":(_)=>MainRoute(),
          "/register":(context)=>RegisterRoute(),
          "/login":(context)=>LoginRoute(),
          "/start":(context)=>StartRoute(),
          //"/profile":(context)=>ProfilePage()
        }
      ),
    );


