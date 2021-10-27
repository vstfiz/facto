import 'dart:async';

import 'package:facto/service/auth/auth.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/view/auth/log_in.dart';
import 'package:facto/view/create_feed/create_feed.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreenState createState ()=> _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState() {
    super.initState();
    navigate();
  }

  navigate() {
    Timer time = new Timer(new Duration(milliseconds: 1500),() async {
      if (Globals.user.email != null && Globals.user.email != "") {
        await fdb.FirebaseDB.getUserDetails(user.uid, context).whenComplete(() => Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) {
          return HomeScreen(true);
        })));

        print(Globals.user.email);
      } else {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) {
          return LogIn();
        }));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: Globals.getWidth(200),
          height: Globals.getHeight(200),
          child: Image.network(Images.logo),
        ),
      ),
    );
  }
}