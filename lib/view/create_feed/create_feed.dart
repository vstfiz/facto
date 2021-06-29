import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateFeed extends StatefulWidget {
  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Stack(
        children: [
          Positioned(
            child: TopBar(),
            top: 0.0,
          ),
          Positioned(
            child: SecondaryTopBar(new Text('Form')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
            top: 150,
            left: 400,
            child: Text(
              'Hi, Vivek',
              style: TextStyle(
                  fontFamily: 'Livvic', color: Color(0xFFA90015), fontSize: 20),
            ),
          ),
          Positioned(
              top: 200,
              left: 400,
              child: Container(
                height: 450,
                width: 800,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      child: Text(
                        'Create Feed',
                        style: TextStyle(fontSize: 24),
                      ),
                      top: 10,
                      left: 50,
                    ),
                    Positioned(
                      top: 50,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Claim', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 500,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Truth ', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 500,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Urls    ', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 200,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Tags  ', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 250,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Language', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 300,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Geo   ', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 475,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 350,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Category', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 450,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.green, width: 2.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 400,
                        left: 600,
                        child: Container(
                          height: 30,
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFF5A5A5A)),
                          child: TextButton(
                            child: Text(
                              'Submit For Review',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 270,
                        left: 630,
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Color(0xFFA90015), width: 1.0)),
                          child: TextButton(
                            child: Text(
                              'Upload',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFFA90015)),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 120,
                        left: 565,
                        child: SizedBox(
                          height: 120,
                          width: 200,
                          child: IconButton(
                            icon:
                           Icon(Icons.image_outlined),

                            iconSize: 150,
                            color: Colors.grey,
                          ),
                        ))
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
