import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      child:  Container(
          width: Globals.width,
          height: Globals.height * 2 / 33,
          child: Stack(
            children: [
              Positioned(
                top: 5,
                bottom: 5,
                left: Globals.width / 50,
                child: Image.asset(
                  Images.logo,
                  width: 150,
                ),
              ),
              Positioned(
                right: Globals.width / 55,
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.person_rounded), onPressed: (){},iconSize: 30,),
                    Text('Vivek',style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: 'Livvic'),),
                    IconButton(
                      icon: Icon(Icons.arrow_drop_down),
                      color: Colors.black,
                      iconSize: 30,
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
