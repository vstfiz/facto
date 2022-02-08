library globals;

import 'dart:convert';
import 'dart:math';
import 'package:facto/model/user.dart';
import 'package:facto/view/analytics/analytics.dart';
import 'package:facto/view/configurations/configurations.dart';
import 'package:facto/view/create_ads/ad_data.dart';
import 'package:facto/view/create_ads/create_ads.dart';
import 'package:facto/view/create_feed/create_feed.dart';
import 'package:facto/view/dashboard/dashboard.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:facto/view/manage_claims/manage_claims.dart';
import 'package:facto/view/manage_rss/manage_rss.dart';
import 'package:facto/view/manage_users/manage_users.dart';
import 'package:facto/view/partner_requests/partner_requests.dart';
import 'package:facto/view/prod_feeds/prod_feeds.dart';
import 'package:facto/view/rejected_feeds/rejected_feeds.dart';
import 'package:facto/view/review/review.dart';
import 'package:facto/widgets/side_bar_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Globals {
  static double height = 0.0;
  static double width = 0.0;
  static String userLevel;

  static int selectedIndex = 0;
  static User user = new User("", "", "", "");
  static User mainUser = new User("", "", "", "");
  static bool isDeleted = false;

  static String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  static double getHeight(double value){
    return (value/781) * Globals.height;
  }

  static double getWidth(double value){
    return (value/1600) * Globals.width;
  }

  static var tabs = userLevel=='Partner'?[
  new SideBarTab('Create Partner Requests', 0),
  new SideBarTab('Manage Requests', 1),
  ]:[
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
            if(userLevel == 'Partner'){
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return CreateFeed(true);
              }));
            }
            else{
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return Dashboard(true);
              }));
            }
          }
        }
        break;
      case 1:
        {
          if (selectedIndex != 1) {
            selectedIndex = 1;
            if(userLevel == 'Partner'){
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return PartnerRequests(true);
              }));
            }
            else{
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return ManageClaims(true);
              }));
            }
          }
        }
        break;
      case 2:
        {
          if (selectedIndex != 2) {
            selectedIndex = 2;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return ManageRSS();
            }));
          }
        }
        break;
      case 3:
        {
          if (selectedIndex != 3) {
            if(userLevel == 'Admin'){
              selectedIndex = 3;
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return AdData();
              }));
            }
          }
        }
        break;
      case 4:
        {
          if (selectedIndex != 4) {
            selectedIndex = 4;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return CreateFeed(true);
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
              return ProdFeeds(true,true);
            }));
          }
        }
        break;
      case 6:
        {
          if (selectedIndex != 6) {
            if (userLevel == 'Admin') {
              selectedIndex = 6;
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return RejectedFeeds();
              }));
            }
          }
        }
        break;
      case 7:
        {
          if (selectedIndex != 7) {
            if (userLevel == 'Admin') {
              selectedIndex = 7;
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return Review(true);
              }));
            }
          }
        }
        break;
      case 8:
        {
          if (selectedIndex != 8) {
            if(userLevel == 'Admin'){
              selectedIndex = 8;
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return PartnerRequests(true);
              }));
            }
          }
        }
        break;
      case 9:
        {
          if (selectedIndex != 9) {
            selectedIndex = 9;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return Analytics();
            }));
          }
        }
        break;
      case 10:
        {
          if (selectedIndex != 10) {
            if (userLevel == 'Admin')
            {
              selectedIndex = 10;
              Navigator.of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return ManageUsers();
              }));
            }
          }
        }
        break;
      case 11:
        {
          if (selectedIndex != 11) {
            selectedIndex = 11;
            Navigator.of(context)
                .pushReplacement(new MaterialPageRoute(builder: (context) {
              return Config();
            }));
          }
        }
        break;
    }
  }
}
