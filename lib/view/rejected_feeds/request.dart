import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
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
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _claimController = new TextEditingController();
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
                height: Globals.getHeight(80),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      Images.logo,
                      width: Globals.getWidth(100),
                      height: Globals.getHeight(50),
                    ),
                    Container(
                        child: LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                        ),
                        width: Globals.getWidth(200))
                  ],
                )))));
  }

  _getData() async {
    claim = await fdb.FirebaseDB.getRejFeedFromId(this.widget.claimId, context);
    setState(() {
      isLoading = false;
      _claimController.text = claim[0];
      _dateController.text = claim[1];
      _commentController.text = claim[2];
      status = claim[4];
    });
  }

  Widget _loadingScreen(String value) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white,
        content: Container(
            height: Globals.getHeight(80),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  Images.logo,
                  width: Globals.getWidth(100),
                  height: Globals.getHeight(50),
                ),
                Container(
                    child: LinearProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                    ),
                    width: Globals.getWidth(200))
              ],
            ))));
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
                    top: Globals.getHeight(200),
                    left: Globals.getWidth(400),
                    child: Container(
                      height: Globals.getHeight(450),
                      width: Globals.getWidth(800),
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Positioned(
                              right: Globals.getWidth(10),
                              child: Container(
                                  child: DropdownButton<String>(
                                value: status,
                                icon: const Icon(Icons.settings),
                                iconSize: Globals.getWidth(24),
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
                            top: Globals.getHeight(50),
                            left: Globals.getWidth(40),
                            child: Row(
                              children: [
                                Text('Claim',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(50),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(500),
                                  height: Globals.getHeight(30),
                                  child: TextField(
                                    controller: _claimController,
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
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
                                Text('Date ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(50),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(500),
                                  height: Globals.getHeight(30),
                                  child: TextField(
                                    controller: _dateController,
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: Globals.getHeight(150),
                            left: Globals.getWidth(40),
                            child: Row(
                              children: [
                                Text('Rejected Comment',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(30),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(400),
                                  height: Globals.getHeight(30),
                                  child: TextField(
                                    controller: _commentController,
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: Globals.getHeight(210),
                            left: Globals.getWidth(40),
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: Globals.getHeight(200),
                                width: Globals.getWidth(400),
                                child: TextButton(
                                  onPressed: _launchURL,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(claim[3]))),
                              ),
                              placeholder: (context, url) => Center(
                                child: Container(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Row(children: [
                                Icon(
                                  Icons.error,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Text('Error Loading Image')
                              ],),
                              imageUrl: claim[3],
                            ),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                    top: Globals.getHeight(700),
                    left: Globals.getWidth(800),
                    child: Row(
                      children: [
                        Container(
                          height: Globals.getHeight(60),
                          width: Globals.getWidth(170),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFF5A5A5A)),
                          child: TextButton(
                            onPressed: () async {
                              _loadingDialog('Deleting Feed...');
                              await fdb.FirebaseDB.deleteFeed(
                                  this.widget.claimId, context);
                              Navigator.pop(context);
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(builder: (context) {
                                return Request(this.widget.claimId);
                              }));
                            },
                            child: Text(
                              'Delete',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Globals.getWidth(50),
                        ),
                        Container(
                          height: Globals.getHeight(60),
                          width: Globals.getWidth(170),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFF5A5A5A)),
                          child: TextButton(
                            onPressed: () async {
                              _loadingDialog('Uploading Data...');
                              await fdb.FirebaseDB.updateRejFeedWithData(_commentController.text,_dateController.text,_claimController.text,
                                  status, this.widget.claimId, context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Save',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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
