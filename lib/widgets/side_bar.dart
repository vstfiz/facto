import 'package:facto/util/globals.dart';
import 'package:facto/widgets/side_bar_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Globals.height * 31 / 33,
      width: Globals.width / 6,
      color: Colors.grey[500],
      padding: EdgeInsets.symmetric(
          vertical: Globals.userLevel=='Partner'?Globals.height * 12/ 30:Globals.height / 15,),
      child: ListView(
        children: Globals.tabs,
        ),
      );
  }
}
