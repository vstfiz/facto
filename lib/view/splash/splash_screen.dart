import 'dart:async';

import 'package:facto/util/images.dart';
import 'package:facto/view/create_feed/create_feed.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  navigate(){
    Timer time = new Timer(new Duration(milliseconds: 1500),(){
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
        return HomeScreen();
      }));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          child: Image.asset(Images.logo),
        ),
      ),
    );
  }
}