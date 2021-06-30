import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondaryTopBar extends StatelessWidget {
  final Widget centerWidget;
  SecondaryTopBar(this.centerWidget);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      child:  Container(
          width: Globals.width * 5 / 6,
          height: Globals.height * 1 / 15,
          child: Stack(
            children: [
              Center(
                child: this.centerWidget,
              ),
            ],
          )),
    );
  }
}
