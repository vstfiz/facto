import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto/model/claims.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/partner_requests/partner_requests.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class Request extends StatefulWidget{
  final String claimId;

  Request(this.claimId);
  
  @override
  _RequestState createState()=> _RequestState();
}

class _RequestState extends State<Request>{
  bool isLoading = true;
  TextEditingController _commentController = new TextEditingController();
  Claims claim;
  String status;
  String tags;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _loadingDialog(String value) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
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
                            fontFamily: "Livvic",
                            fontSize: 23,
                            letterSpacing: 1),
                      )
                    ],
                  ),
                ))));
  }

  _getData()async{
    claim = await fdb.FirebaseDB.getPartnerRequestFromId(this.widget.claimId).whenComplete((){
      setState(() {
        isLoading = false;
      });
    });
    status = claim.status;
    tags = '';
    await claim.tags.forEach((element) {
      tags = tags + element + ", ";
    });

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
            child: SecondaryTopBar(new Text('Manage Requests')),
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
                    return PartnerRequests(true);
                  }));
                },
              )),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
              top: 150,
              left: 400,
              child: Container(
                height: 600,
                width: 900,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Claim',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 500,
                            height: 30,
                            child: Text(
                              claim.news,
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
                          Text('Truth ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 500,
                            height: 30,
                            child: Text(
                              claim.truth,
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
                          Text('Url    ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: Text(
                              claim.url1,
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
                          Text('Date  ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,

                            child: Text(
                              claim.date,
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
                          Text('Tags',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,

                            child: AutoSizeText(
                              tags,
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),softWrap: true,
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
                          Text('Language',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 40,
                          ),
                          SizedBox(
                            width: 400,

                            child: Text(
                              claim.language,
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),softWrap: true,
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
                          Text('Geo',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,

                            child: AutoSizeText(
                              claim.geo,
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 400,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Category',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 40,
                          ),
                          SizedBox(
                            width: 400,
                            child: Text(
                              claim.category,
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 450,
                      left: 40,
                      child: Row(
                        children: [
                          Text('If Rejected then why',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 40,
                          ),
                          SizedBox(
                            width: 400,
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.only(bottom: 10)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 530,
                        left: 600,
                        child:
                       Row(
                         children: [
                           Container(
                             height: 40,
                             width: 100,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(6),
                                 color: Color(0xFF5A5A5A)),
                             child: TextButton(
                               onPressed: () async{

                                 _loadingDialog('Uploading Data...');
                                 await fdb.FirebaseDB.updatePartnerRequest(_commentController.text,status,this.widget.claimId);
                                 Navigator.pop(context);
                               },
                               child: Text(
                                 'Approve',
                                 style:
                                 TextStyle(fontSize: 18, color: Colors.white),
                               ),
                             ),
                           ),SizedBox(width: 50,) ,Container(
                             height: 40,
                             width: 100,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(6),
                                 color: Color(0xFF5A5A5A)),
                             child: TextButton(
                               onPressed: () async{
                                 setState(() {
                                   status = 'Rejected';
                                 });
                                 _loadingDialog('Uploading Data...');
                                 await fdb.FirebaseDB.updatePartnerRequest(_commentController.text,status,this.widget.claimId);
                                 Navigator.pop(context);
                               },
                               child: Text(
                                 'Reject',
                                 style:
                                 TextStyle(fontSize: 18, color: Colors.white),
                               ),
                             ),
                           )
                         ],
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