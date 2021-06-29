import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAds extends StatefulWidget{
  @override
  _CreateAdsState createState()=> _CreateAdsState();
}

class _CreateAdsState extends State<CreateAds>{
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
              child: Container(
                height: 550,
                width: 1100,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
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
                      top: 100,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Text Field', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: 20,
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
                    Positioned(top:250,left:400,child: Text('Sponsored By', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),),
                    Positioned(
                      top: 250,
                      left: 400,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 75,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10.0),

                                border: UnderlineInputBorder(

                                )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 510,
                        left: 170,
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
                      left:5,
                        child: SizedBox(
                          height: 120,
                          width: 200,
                          child: IconButton(
                            icon:
                            Icon(Icons.image_outlined),

                            iconSize: 420,
                            color: Colors.grey,
                          ),
                        ))
                  ],
                ),
              )),
          Positioned(top:720,right:100,child: Container(
            height: 50,
            width: 170,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xFF5A5A5A)),
            child: TextButton(
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),)
        ],
      ),
    );
  }

}