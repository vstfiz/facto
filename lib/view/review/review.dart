import 'package:facto/model/feeds.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/review/review_feed.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class Review extends StatefulWidget{
  final bool feedLanguage;

  Review(this.feedLanguage);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review>{
  bool allSelected = false;
  var feeds =
  List.filled(0, new Feeds.forReview('', '', '',false,'',false), growable: true);
  bool isLoading = true;

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
    feeds = await fdb.FirebaseDB.getReviewFeed(this.widget.feedLanguage,context);
    setState(() {
      isLoading = false;
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
      body: isLoading
          ? _loadingScreen('Getting Data from Server.....')
          : Stack(
        children: [
          Positioned(
            child: TopBar(),
            top: 0.0,
          ),
          Positioned(
            child: SecondaryTopBar(new Text('Review Feeds')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(
            top: 10 + Globals.height * 2 / 33,
            right: Globals.width / 55,
            child: Row(
              children: [
                Text('Feed: ' +
                    (this.widget.feedLanguage ? 'English' : 'Hindi')),
                Switch(
                  activeColor: Colors.blueGrey,
                  value: this.widget.feedLanguage,
                  onChanged: (value) {
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder: (context) {
                          return Review(value);
                        }));
                  },
                )
              ],
            ),
          ),
          Positioned(
              left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
            top: Globals.height * 81 / 495,
            left: Globals.width / 10,
            child: Container(
              padding: EdgeInsets.only(left: Globals.height / 5),
              width: Globals.width * 5 / 6,
              height: Globals.height / 10,
              child: Row(
                children: [
                  Container(
                      height: 40,
                      width: Globals.height / 5,
                      decoration: BoxDecoration(
                          color: Color(0xFF1E7D34),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () async {
                          _loadingDialog('Getting Data from Server.....');
                          var pendFeeds = await fdb.FirebaseDB.getFilteredReviewFeeds(
                              'Pending', true, context);
                          setState(() {
                            feeds = pendFeeds;
                          });
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'Total Pending  Feeds',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Livvic'),
                          ),
                        ),
                      )),
                  SizedBox(
                    width: Globals.width / 20,
                  ),
                  Container(
                      height: 40,
                      width: Globals.height / 5,
                      decoration: BoxDecoration(
                          color: Color(0xFF128799),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () async {
                          _loadingDialog('Getting Data from Server.....');
                          var publishedFeeds = await fdb.FirebaseDB.getFilteredReviewFeeds(
                              'True',true, context);
                          setState(() {
                            feeds = publishedFeeds;
                          });
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'Total Published Feeds',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Livvic'),
                          ),
                        ),
                      )),
                  SizedBox(
                    width: Globals.width / 20,
                  ),
                  Container(
                    height: 40,
                    width: Globals.height / 5,
                    decoration: BoxDecoration(
                        color: Color(0xFFE6B00E),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () async {
                        _loadingDialog('Getting Data from Server.....');
                        var pendVideoFeeds = await fdb.FirebaseDB.getFilteredReviewFeeds(
                            'Pending', false,  context);
                        setState(() {
                          feeds = pendVideoFeeds;
                        });
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          'Total Video Feeds Pending',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'Livvic'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Globals.width / 20,
                  ),
                  Container(
                    height: 40,
                    width: Globals.height / 5,
                    decoration: BoxDecoration(
                        color: Color(0xFFBF2E3C),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () async {
                        _loadingDialog('Getting Data from Server.....');
                        var publishedVideoFeeds = await fdb.FirebaseDB.getFilteredReviewFeeds(
                            'True', false, context);
                        setState(() {
                          feeds = publishedVideoFeeds;
                        });
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          'Total Video Feeds Published',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'Livvic'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 250,
              left: 300,
              child: Container(
                height: 450,
                width: 1250,
                child: Card(
                  elevation: 12,
                  child: SingleChildScrollView(
                    child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Editor',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Claim',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                        rows: List.generate(feeds.length, (index) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(GestureDetector(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: feeds[index].isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          feeds[index].isSelected = value;
                                        });
                                      },
                                      checkColor: Color(0xFF00A424),
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states.contains(
                                            MaterialState.selected)) {
                                          return Colors.white;
                                        }
                                        return null;
                                      }),
                                    ),
                                    Text(feeds[index].requestedBy)
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (context) {
                                            return ReviewFeed(feeds[index].claimId);
                                          }));
                                },
                              )),
                              DataCell(GestureDetector(
                                child: Text(feeds[index].time),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (context) {
                                            return ReviewFeed(feeds[index].claimId);
                                          }));
                                },
                              )),
                              DataCell(GestureDetector(
                                child: Text(feeds[index].claim),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (context) {
                                            return ReviewFeed(feeds[index].claimId);
                                          }));
                                },
                              )),
                            ],
                          );
                        })),
                  ),
                ),
              )),
          Positioned(
              top: 710,
              left: 300,
              child: Row(
                children: [
                  Checkbox(
                    value: allSelected,
                    onChanged: (value) {
                      setState(() {
                        allSelected = value;
                        feeds.forEach((element) {
                          element.isSelected = value;
                        });
                      });
                    },
                    checkColor: Color(0xFF00A424),
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return null;
                        }),
                  ),
                  Text('Select All')
                ],
              )),
          Positioned(
              top: 720,
              left: 1300,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xFF343434)),
                    child: TextButton(
                      onPressed: () {
                        _loadingDialog('Publishing Feeds.....');
                        feeds.forEach((element) async {
                          if (element.isSelected) {
                            await fdb.FirebaseDB.publishFeeds(
                                element.claimId,element.feedType);
                          }
                        });
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(builder: (context) {
                              return Review(true);
                            }));
                      },
                      child: Text(
                        'Publish',
                        style:
                        TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}