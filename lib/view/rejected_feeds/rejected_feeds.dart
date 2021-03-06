import 'package:facto/model/feeds.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/view/rejected_feeds/request.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class RejectedFeeds extends StatefulWidget {
  @override
  _RejectedFeedsState createState() => _RejectedFeedsState();
}

class _RejectedFeedsState extends State<RejectedFeeds> {
  bool isLoading = true;
  String status = 'Rejected';


  var rejFeeds = List.filled(
      0,
      Feeds.rejected('', '', '', '', true),
      growable: true);

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    rejFeeds = await fdb.FirebaseDB.getRejectedFeeds(context).whenComplete(() {
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
                height: Globals.getHeight(80),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(Images.logo,width: Globals.getWidth(100),height: Globals.getHeight(50),),

                        Container(child:  LinearProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                        ),width: Globals.getWidth(200))
                      ],
                    )
                ))));
  }

  Widget _loadingScreen(String value) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        backgroundColor: Colors.white,
        content: Container(
            height: Globals.getHeight(80),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Images.logo,width: Globals.getWidth(100),height: Globals.getHeight(50),),

                    Container(child:  LinearProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                    ),width: Globals.getWidth(200))
                  ],
                )
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
                  child: SecondaryTopBar(new Text('Rejected Feeds')),
                  top: Globals.height * 2 / 33,
                  right: 0.0,
                ),
                Positioned(
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
                Positioned(
                    top: Globals.getHeight(250),
                    left: Globals.getWidth(350),
                    child: Container(
                      height: Globals.getHeight(500),
                      width: Globals.getWidth(1100),
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
                                      'Feed',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    ),
                                DataColumn(
                                    label:
                                    Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    )
                                    ),
                              ],
                              rows: List.generate(rejFeeds.length, (index) {
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(GestureDetector(
                                      child:Text(
                                          rejFeeds[index].publisher
                                      ),
                                        
                                      onTap: () {
                                        if(rejFeeds[index].feedType){
                                          Navigator.of(context).pushReplacement(
                                              new MaterialPageRoute(
                                                  builder: (context) {
                                                    return Request(rejFeeds[index].claimId);
                                                  }));
                                        }
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(
                                          rejFeeds[index].time
                                          ),
                                      onTap: () {
                                        if(rejFeeds[index].feedType){
                                          Navigator.of(context).pushReplacement(
                                              new MaterialPageRoute(
                                                  builder: (context) {
                                                    return Request(rejFeeds[index].claimId);
                                                  }));
                                        }
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(rejFeeds[index].claim),
                                      onTap: () {
                                        if(rejFeeds[index].feedType){
                                          Navigator.of(context).pushReplacement(
                                              new MaterialPageRoute(
                                                  builder: (context) {
                                                    return Request(rejFeeds[index].claimId);
                                                  }));
                                        }
                                      },
                                    )),
                                    DataCell(
                                        DropdownButton<String>(
                                          value: status,
                                          icon: const Icon(Icons.settings),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: const TextStyle(color: Colors.black),
                                          onChanged: (String newValue)async {
                                            _loadingDialog('Updating Status....');
                                            await fdb.FirebaseDB.updateRejFeed(newValue, rejFeeds[index].claimId, context);
                                            var upFeed = await fdb.FirebaseDB.getRejectedFeeds(context);
                                            setState(() {
                                              status = newValue;
                                              rejFeeds = upFeed;
                                            });
                                            Navigator.pop(context);
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
                                        )
                                    ),
                                  ],
                                );
                              })),
                        ),
                      ),
                    )),
              ],
            ),
    );
  }
}
