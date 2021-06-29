library globals;

import 'package:facto/view/create_ads/create_ads.dart';
import 'package:facto/view/create_feed/create_feed.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:facto/view/manage_claims/manage_claims.dart';
import 'package:facto/view/prod_feeds/prod_feeds.dart';
import 'package:facto/widgets/side_bar_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Globals {
  static double height = 0.0;
  static double width = 0.0;

  static int selectedIndex = 0;

  static var tabs = [
    new SideBarTab('Home', 0),
    new SideBarTab('Manage Claims', 1),
    new SideBarTab('Manage RSS', 2),
    new SideBarTab('Create Ads', 3),
    new SideBarTab('Create Feeds', 4),
    new SideBarTab('Prod Feeds', 5),
    new SideBarTab('Rejected Feeds', 6),
    new SideBarTab('Review', 7),
    new SideBarTab('Partner Requests', 8),
    new SideBarTab('Analytics', 9),
    new SideBarTab('Manage Users', 10),
    new SideBarTab('Configuarations', 11)
  ];

  static runTabNavigator(var index, BuildContext context) {
    switch (index) {
      case 0:
        {
          if (selectedIndex != 0) {
            selectedIndex = 0;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          }
        }
        break;
      case 1:
        {
          if (selectedIndex != 1) {
            selectedIndex = 1;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return ManageClaims();
            }));
          }
        }
        break;
      case 2:
        {
          if (selectedIndex != 2) {
            selectedIndex = 2;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          }
        }
        break;
      case 3:
        {
          if (selectedIndex != 3) {
            selectedIndex = 3;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return CreateAds();
            }));
          }
        }
        break;
      case 4:
        {
          if (selectedIndex != 4) {
            selectedIndex = 4;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return CreateFeed();
            }));
          }
        }
        break;
      case 5:
        {
          if (selectedIndex != 5) {
            selectedIndex = 5;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return ProdFeeds();
            }));
          }
        }
        break;

    }
  }
}
