import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TopBar extends StatefulWidget {
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  OverlayEntry floatingDropdown;
  bool isDropdownOpened = false;

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        // You can change the position here
        right: Globals.width / 55,
        width: 300,
        top: 30,
        height: 170,
        // Any child
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(top:10,left:10,child: CircleAvatar(
                radius: 40,
                child: Text('Profile Picture'),
              )),
              Positioned(
                top: 40,
                  right: 30,
                  child: Center(child: Text(
                    'Vivek Sharma',
                    style: TextStyle(fontFamily: 'Livvic',fontSize: 20),
                    overflow: TextOverflow.fade,
                  ),)),
              Positioned(
                top: 90,
                  child: SizedBox(
                    width: 300,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 2.0,
                    ),
                  )),
              Positioned(
                top: 110,
                  right: 10,
                  child: SizedBox(
                width: 115,
                height: 40,
                child: Center(
                  child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: TextButton(
                            onPressed: null,
                            child: Text(
                              'Log Out',
                              style: TextStyle(color: Color(0xFFFF4669)),
                            )),
                      )),
                ),
              ))
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      child: Container(
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
                    IconButton(
                      icon: Icon(Icons.person_rounded),
                      onPressed: () {},
                      iconSize: 30,
                    ),
                    Text(
                      'Vivek',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Livvic'),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_drop_down),
                      color: Colors.black,
                      iconSize: 30,
                      onPressed: () {
                        setState(() {
                          if (isDropdownOpened) {
                            floatingDropdown.remove();
                          } else {
                            // findDropdownData();
                            floatingDropdown = _createFloatingDropdown();
                            Overlay.of(context).insert(floatingDropdown);
                          }

                          isDropdownOpened = !isDropdownOpened;
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
