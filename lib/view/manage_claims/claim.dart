import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/manage_claims/manage_claims.dart';
import 'package:facto/view/manage_users/manage_users.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class Claim extends StatefulWidget {
  final String claimId;

  Claim(this.claimId);


  _ClaimState createState() => _ClaimState();
}

class _ClaimState extends State<Claim> {
  bool isLoading = true;
  var claim = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData()async{
    claim = await fdb.FirebaseDB.getClaimFromId(this.widget.claimId).whenComplete((){
      setState(() {
        isLoading = false;
      });
    });
    print(claim.length);
  }
  Widget _loadingScreen(String value) {
    return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white,
        content: Container(
            height: 60,
            child: Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    value,
                    style: TextStyle(
                        fontFamily: "Livvic", fontSize: 23, letterSpacing: 1),
                  )
                ],
              ),
            )));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: isLoading?_loadingScreen('Getting Data from Servers.....'):Stack(
        children: [
          Positioned(
            child: TopBar(),
            top: 0.0,
          ),
          Positioned(
            child: SecondaryTopBar(new Text('Manage Claims')),
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
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                    return ManageClaims(true);
                  }));
                },
              )),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
              top: 200,
              left: 400,
              child: Container(
                height: 450,
                width: 800,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(right:10,child: Container(child: Row(children: [
                      Text(claim[5]),
                      SizedBox(width: 10,),
                      IconButton(icon: Icon(Icons.arrow_drop_down),
                          onPressed: null)
                    ],),)),
                    Positioned(
                      top: 50,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Name',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 500,
                            height: 30,
                            child: Text(
                              claim[0],
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),
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
                          Text('Claim ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 500,
                            height: 30,
                            child: Text(
                              claim[1],
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),
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
                          Text('Url1    ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: Text(
                              claim[2],
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),
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
                          Text('Url2  ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: Text(
                              claim[3],
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),
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
                          Text('Description',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 400,
                            height: 80,
                            child: AutoSizeText(
                              claim[4],
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),minFontSize: 15,overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Positioned(
                      top: 350,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Comment', style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  contentPadding: EdgeInsets.only(bottom: 10.0)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(top: 200,
                        left: 600,
                        child: IconButton(
                          icon: Icon(Icons.image_outlined), iconSize: 150,)),
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
                              'Save',
                              style:
                              TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
