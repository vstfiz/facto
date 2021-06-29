import 'package:facto/util/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideBarTab extends StatefulWidget {
  final String name;
  final int index;
  _SideBarTabState createState() => _SideBarTabState();
  SideBarTab(this.name,this.index);
}

class _SideBarTabState extends State<SideBarTab> {
  @override
  Widget build(BuildContext context) {
    return Globals.selectedIndex == this.widget.index?Container(
      width: Globals.width / 6,
      height: Globals.height / 15,
      decoration: BoxDecoration(
          color: Color(0xFF343434),
          border: Border(
             left: BorderSide(
            color: Colors.white,width: 10
          )
          )
      ),
      child: TextButton(
        onPressed: () {
          Globals.runTabNavigator(this.widget.index, context);
        },
        child: Center(
          child: Text(this.widget.name,style: TextStyle(color:Colors.white,fontFamily: 'Livvic'),),
        ),
      ),
    ):Container(
      width: Globals.width / 6,
      height: Globals.height / 15,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        ),
      child: TextButton(
        onPressed: () {
          Globals.runTabNavigator(this.widget.index, context);
        },
        child: Center(
          child: Text(this.widget.name,style: TextStyle(color: Globals.selectedIndex==this.widget.index?Colors.black:Colors.white,fontFamily: 'Livvic'),),
        ),
      ),
    );
  }
}