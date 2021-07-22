import 'package:facto/service/auth/auth.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/view/auth/log_in.dart';
import 'package:facto/view/configurations/configurations.dart';
import 'package:facto/view/create_ads/ad_data.dart';
import 'package:facto/view/create_ads/create_ads.dart';
import 'package:facto/view/create_feed/create_feed.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:facto/view/manage_claims/claim.dart';
import 'package:facto/view/manage_claims/manage_claims.dart';
import 'package:facto/view/manage_rss/manage_rss.dart';
import 'package:facto/view/manage_users/manage_users.dart';
import 'package:facto/view/partner_requests/partner_requests.dart';
import 'package:facto/view/prod_feeds/prod_feeds.dart';
import 'package:facto/view/rejected_feeds/rejected_feeds.dart';
import 'package:facto/view/review/review.dart';
import 'package:facto/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
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
            home: StreamBuilder(
              stream: auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  user = snapshot.data;
                  print(user.toString());
                  Globals.user.email = user.email;
                  Globals.user.dp = user.photoURL;
                  Globals.user.uid = user.uid;
                  Globals.user.name = user.displayName;
                }
                return SplashScreen();
              },
            ));
      });
    });

  }
}
