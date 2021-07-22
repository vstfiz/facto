import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/manage_claims/manage_claims.dart';
import 'package:facto/view/rejected_feeds/rejected_feeds.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;
import 'package:url_launcher/url_launcher.dart';

class Request extends StatefulWidget {
  final String claimId;

  Request(this.claimId);

  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool isLoading = true;
  TextEditingController _commentController = new TextEditingController();
  var claim = [];
  String status;

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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blueGrey),
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



  _getData() async {
    claim = await fdb.FirebaseDB.getRejFeedFromId(this.widget.claimId, context);
    setState(() {
      isLoading = false;
      status = claim[4];
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

  void _launchURL() async => await canLaunch(claim[3])
      ? await launch(claim[3])
      : throw 'Could not launch ${claim[3]}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: isLoading
          ? _loadingScreen('Getting Data from Servers.....')
          : Stack(
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
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(builder: (context) {
                          return RejectedFeeds();
                        }));
                      },
                    )),
                Positioned(
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
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
                              right: 10,
                              child: Container(
                                  child:
                                  DropdownButton<String>(
                                value: status,
                                icon: const Icon(Icons.settings),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String newValue) {
                                  setState(() {
                                    status = newValue;
                                  });
                                  print(status);
                                },
                                items: <String>[
                                  'Rejected',
                                  'True',
                                  'Pending'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ))),
                          Positioned(
                            top: 50,
                            left: 40,
                            child: Row(
                              children: [
                                Text('Claim',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 500,
                                  height: 30,
                                  child: Text(
                                    claim[0],
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
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
                                Text('Date ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 50,
                                ),
                                SizedBox(
                                  width: 500,
                                  height: 30,
                                  child: Text(
                                    claim[1],
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
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
                                Text('Rejected Comment',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 400,
                                  height: 30,
                                  child: Text(
                                    claim[2],
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              top: 210,
                              left: 40,
                              child: Container(
                                height: 200,
                                width: 400,
                                child: TextButton(
                                  onPressed: _launchURL,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(claim[3]))),
                              )),

                        ],
                      ),
                    )),Positioned(
                    top: 700,
                    left: 800,
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFF5A5A5A)),
                          child: TextButton(
                            onPressed: () async {
                              _loadingDialog('Deleting Feed...');
                              await fdb.FirebaseDB.deleteFeed(
                                  this.widget.claimId,context);
                              Navigator.pop(context);
                              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return Request(this.widget.claimId);}));
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                          height: 60,
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFF5A5A5A)),
                          child: TextButton(
                            onPressed: () async {
                              _loadingDialog('Uploading Data...');
                              await fdb.FirebaseDB.updateRejFeed(
                                  status,
                                  this.widget.claimId,context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
    );
  }
}
