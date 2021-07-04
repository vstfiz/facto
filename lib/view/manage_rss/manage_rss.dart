import 'dart:async';
import 'package:facto/model/claims.dart';
import 'package:facto/model/rss.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/manage_rss/rss.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class ManageRSS extends StatefulWidget {
  ManageRSS();

  _ManageRSSState createState() => _ManageRSSState();
}

class _ManageRSSState extends State<ManageRSS> {
  bool allSelected = false;
  var rss =
      List.filled(0, new RSSs('', '', '', '', '', false, ''), growable: true);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  OverlayEntry floatingDropdown;
  bool isDropdownOpened = false;

  OverlayEntry _createFloatingDropdown(BuildContext context) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        // You can change the position here
        right: 400,
        width: 150,
        top: 200,
        height: 210,
        // Any child
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Server.....');
                    var allRSS = await fdb.FirebaseDB.getRSS(context);
                    setState(() {
                      rss = allRSS;
                      floatingDropdown.remove();
                      setState(() {
                        isDropdownOpened = !isDropdownOpened;
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'All',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Server.....');
                    var pendRSS =
                        await fdb.FirebaseDB.getFilteredRSS('Pending', context);
                    setState(() {
                      rss = pendRSS;
                      floatingDropdown.remove();
                      setState(() {
                        isDropdownOpened = !isDropdownOpened;
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Pending',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Server.....');
                    var rejRSS = await fdb.FirebaseDB.getFilteredRSS(
                        'Rejected', context);
                    setState(() {
                      rss = rejRSS;
                      floatingDropdown.remove();
                      setState(() {
                        isDropdownOpened = !isDropdownOpened;
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Rejected',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Server.....');
                    var trueRSS =
                        await fdb.FirebaseDB.getFilteredRSS('True', context);
                    setState(() {
                      rss = trueRSS;
                      floatingDropdown.remove();
                      setState(() {
                        isDropdownOpened = !isDropdownOpened;
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'True',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
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

  _getData() async {
    rss = await fdb.FirebaseDB.getRSS(context);
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
                  child: SecondaryTopBar(new Text('Manage RSS')),
                  top: Globals.height * 2 / 33,
                  right: 0.0,
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
                                var pendRSS = await fdb.FirebaseDB.getFilteredRSS(
                                    'Pending', context);
                                setState(() {
                                  rss = pendRSS;
                                });
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  'Total Open RSS Feeds',
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
                                var closedRSS = await fdb.FirebaseDB.getFilteredRSSClosed(
                                    'Pending', context);
                                setState(() {
                                  rss = closedRSS;
                                });
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  'Total Closed RSS Feeds',
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
                                var rejRSS = await fdb.FirebaseDB.getFilteredRSS(
                                    'Rejected', context);
                                setState(() {
                                  rss = rejRSS;
                                });
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  'Total Rejected RSS Feeds',
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
                                    'Source',
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
                                    'Summary',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                                DataColumn(
                                    label: Row(
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.filter_alt),
                                        color: Colors.grey,
                                        onPressed: () {
                                          setState(() {
                                            if (isDropdownOpened) {
                                              floatingDropdown.remove();
                                            } else {
                                              // findDropdownData();
                                              floatingDropdown =
                                                  _createFloatingDropdown(
                                                      context);
                                              Overlay.of(context)
                                                  .insert(floatingDropdown);
                                            }

                                            isDropdownOpened =
                                                !isDropdownOpened;
                                          });
                                        })
                                  ],
                                )),
                                DataColumn(
                                  label: Text(
                                    'Assigned',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                              rows: List.generate(rss.length, (index) {
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(GestureDetector(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: rss[index].isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                rss[index].isSelected = value;
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
                                          Text(rss[index].source)
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return RSS(rss[index].rssId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(rss[index].date),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return RSS(rss[index].rssId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(rss[index].title),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return RSS(rss[index].rssId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(rss[index].status),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return RSS(rss[index].rssId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(rss[index].assigned),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return RSS(rss[index].rssId);
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
                              rss.forEach((element) {
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
              ],
            ),
    );
  }
}
