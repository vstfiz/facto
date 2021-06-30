import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/view/auth/log_in.dart';
import 'package:facto/view/configurations/configurations.dart';
import 'package:facto/view/create_ads/create_ads.dart';
import 'package:facto/view/create_feed/create_feed.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:facto/view/manage_claims/claim.dart';
import 'package:facto/view/manage_claims/manage_claims.dart';
import 'package:facto/view/manage_users/manage_users.dart';
import 'package:facto/view/prod_feeds/prod_feeds.dart';
import 'package:facto/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState()=> _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {

          Globals.height = constraints.maxHeight;
          Globals.width = constraints.maxWidth;

        return MaterialApp(
          title: 'Facto Admin',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: ManageClaims());
      });
    });

  }
}
