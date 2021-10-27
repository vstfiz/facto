import 'package:facto/util/globals.dart';
import 'package:facto/view/create_ads/ad_data.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class CreateAds extends StatefulWidget {
  @override
  _CreateAdsState createState() => _CreateAdsState();
}

class _CreateAdsState extends State<CreateAds> {
  TextEditingController _urlController = new TextEditingController();
  TextEditingController _valueController = new TextEditingController();
  TextEditingController _clientController = new TextEditingController();

  Future<void> _submitDialog() {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              content: Container(
                  height: Globals.getHeight(60),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: Globals.getWidth(40),
                        ),
                        SizedBox(
                          width: Globals.getWidth(20),
                        ),
                        Text(
                          'Ad Succefully Created.',
                          style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 23,
                              letterSpacing: 1),
                        )
                      ],
                    ),
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Dismiss',
                      style: TextStyle(color: Colors.blueGrey),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Stack(
        children: [
          Positioned(
            child: TopBar(),
            top: 0.0,
          ),
          Positioned(
            child: SecondaryTopBar(new Text('Create Ad')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(
              top: 5 + Globals.height * 2 / 33,
              left: 20 + Globals.width / 6,
              child: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) {
                    return AdData();
                  }));
                },
              )),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
              top: Globals.getHeight(150),
              left: Globals.getWidth(400),
              child: Container(
                height: Globals.getHeight(550),
                width: Globals.getWidth(1100),
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      top: Globals.getHeight(50),
                      left: Globals.getWidth(40),
                      child: Row(
                        children: [
                          Text('Url    ', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: Globals.getWidth(50),
                          ),
                          SizedBox(
                            width: Globals.getWidth(400),
                            height: Globals.getHeight(30),
                            child: TextField(
                              controller: _urlController,
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
                      top: Globals.getHeight(100),
                      left: Globals.getWidth(40),
                      child: Row(
                        children: [
                          Text('Text Field', style: TextStyle(fontSize: 20)),
                          SizedBox(
                            width: Globals.getWidth(20),
                          ),
                          SizedBox(
                            width: Globals.getWidth(400),
                            height: Globals.getHeight(30),
                            child: TextField(
                              controller: _valueController,
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
                      top: Globals.getHeight(250),
                      left: Globals.getWidth(400),
                      child: Text('Sponsored By',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Positioned(
                      top: Globals.getHeight(250),
                      left: Globals.getWidth(400),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Globals.getHeight(75),
                          ),
                          SizedBox(
                            width: Globals.getWidth(400),
                            height: Globals.getHeight(30),
                            child: TextField(
                              controller: _clientController,
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 10.0),
                                  border: UnderlineInputBorder()),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: Globals.getHeight(510),
                        left: Globals.getWidth(170),
                        child: Container(
                          width: Globals.getWidth(80),
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
                        top: Globals.getHeight(120),
                        left: Globals.getWidth(5),
                        child: SizedBox(
                          height: Globals.getHeight(120),
                          width: Globals.getWidth(200),
                          child: IconButton(
                            icon: Icon(Icons.image_outlined),
                            iconSize: Globals.getWidth(420),
                            color: Colors.grey,
                          ),
                        ))
                  ],
                ),
              )),
          Positioned(
            top: Globals.getHeight(720),
            right: Globals.getWidth(100),
            child: Container(
              height: Globals.getHeight(50),
              width: Globals.getWidth(170),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xFF5A5A5A)),
              child: TextButton(
                onPressed: () async {
                  if (_urlController.text != null &&
                      _urlController.text != '') {
                    if (_valueController.text != null &&
                        _valueController.text != '') {
                      if (_clientController.text != null &&
                          _clientController.text != '') {
                        await fdb.FirebaseDB.createAd(
                            _urlController.text,
                            _valueController.text,
                            _clientController.text,
                            context);
                        _submitDialog();
                        _clientController.clear();
                        _valueController.clear();
                        _urlController.clear();
                      } else {
                        setState(() {
                          showToast(
                            'Invalid Value in Sponsored Field. Please input valid value',
                            position: ToastPosition.bottom,
                            backgroundColor: Color(0xFF5A5A5A),
                            radius: 8.0,
                            textStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          );
                        });
                      }
                    } else {
                      showToast(
                        'Invalid Value in Text Field. Please input valid value.',
                        position: ToastPosition.bottom,
                        backgroundColor: Color(0xFF5A5A5A),
                        radius: 8.0,
                        textStyle:
                            TextStyle(fontSize: 18.0, color: Colors.white),
                      );
                    }
                  } else {
                    showToast(
                      'Invalid Value in Url Field. Please input valid value.',
                      position: ToastPosition.bottom,
                      backgroundColor: Color(0xFF5A5A5A),
                      radius: 8.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    );
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
