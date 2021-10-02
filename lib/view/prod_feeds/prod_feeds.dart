import 'package:facto/model/feeds.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/review/review_feed.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;
import 'package:universal_html/html.dart';

class ProdFeeds extends StatefulWidget {
  bool feedType;
  bool feedLanguage;

  _ProdFeedState createState() => _ProdFeedState();

  ProdFeeds(this.feedType, this.feedLanguage);
}

class _ProdFeedState extends State<ProdFeeds> {
  bool isLoading = true;
  var prodFeeds = List.filled(
      0,
      Feeds.published(
          'claim', 'language', false, 'time', 'status', 'publisher', 0, 0, ''),
      growable: true);

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    prodFeeds = await fdb.FirebaseDB.getPublishedFeeds(
            this.widget.feedType, this.widget.feedLanguage, context)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
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
          ? _loadingScreen('Getting Data from Servers.....')
          : Stack(
              children: [
                Positioned(
                  child: TopBar(),
                  top: 0.0,
                ),
                Positioned(
                  child: SecondaryTopBar(new Text('Prod Feeds')),
                  top: Globals.height * 2 / 33,
                  right: 0.0,
                ),
                Positioned(
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
                Positioned(
                  top: Globals.height * 81 / 495,
                  left: Globals.width * 4 / 6,
                  child: Container(
                    padding: EdgeInsets.only(left: Globals.height / 5),
                    width: Globals.width * 5 / 6,
                    height: Globals.height / 8,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Feed: ' +
                                (this.widget.feedType ? 'Image' : 'Video')),
                            Switch(
                                value: this.widget.feedType,
                                onChanged: (value) async {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return ProdFeeds(
                                        value, this.widget.feedLanguage);
                                  }));
                                })
                          ],
                        ),
                        Row(
                          children: [
                            Text('Feed: ' +
                                (this.widget.feedLanguage
                                    ? 'English'
                                    : 'Hindi')),
                            Switch(
                                value: this.widget.feedLanguage,
                                onChanged: (value) async {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return ProdFeeds(
                                        this.widget.feedType, value);
                                  }));
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  left: 350,
                  child: Container(
                    height: 500,
                    width: 1100,
                    child: Card(
                      elevation: 12,
                      child: SingleChildScrollView(
                        child: DataTable(
                            columns: <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Feed Published',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Publisher',
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
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Views',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Clicks',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                            rows: List.generate(prodFeeds.length, (index) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(prodFeeds[index].claim)),
                                  DataCell(Text(prodFeeds[index].publisher)),
                                  DataCell(Text(prodFeeds[index].time)),
                                  DataCell(Text(prodFeeds[index].status)),
                                  DataCell(Text(
                                      prodFeeds[index].impressions.toString())),
                                  DataCell(
                                      Text(prodFeeds[index].clicks.toString())),
                                  DataCell(DropdownButton<String>(
                                    icon: const Icon(Icons.settings),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    onChanged: (String newValue) async {
                                      if (newValue == 'Edit') {
                                        if(prodFeeds[index].feedType){
                                          Navigator.of(context).pushReplacement(
                                              new MaterialPageRoute(
                                                  builder: (context) {
                                                    return ReviewFeed(
                                                        prodFeeds[index].claimId);
                                                  }));
                                        }
                                      } else if (newValue == 'Remove') {
                                        _loadingDialog('Deleting Feed....');
                                        await fdb.FirebaseDB.deleteFeed(
                                            prodFeeds[index].claimId, context);
                                        var newa = await fdb.FirebaseDB
                                            .getPublishedFeeds(
                                                this.widget.feedType,
                                                this.widget.feedLanguage,
                                                context);
                                        setState(() {
                                          prodFeeds = newa;
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    items: <String>[
                                      'Remove',
                                      'Edit',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )),
                                ],
                              );
                            })),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
