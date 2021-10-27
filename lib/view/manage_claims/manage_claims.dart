import 'dart:async';
import 'package:facto/model/claims.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

import 'claim.dart';

class ManageClaims extends StatefulWidget {
  final bool feedType;

  ManageClaims(this.feedType);

  _ManageClaimsState createState() => _ManageClaimsState();
}

class _ManageClaimsState extends State<ManageClaims> {
  var selectedPage = 1;
  bool allSelected = false;
  var claims =
      List.filled(0, new Claims('', '', '', '', '', false, ''), growable: true);
  var curr =
      List.filled(0, new Claims('', '', '', '', '', false, ''), growable: true);
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
        right: Globals.getWidth(400),
        width: Globals.getWidth(150),
        top: Globals.getHeight(200),
        height: Globals.getHeight(210),
        // Any child
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Server.....');
                    var allClaims = await fdb.FirebaseDB.getClaims(this.widget.feedType, context);
                    print(allClaims);
                    setState(() {
                      claims = allClaims;
                      if (claims.length > 10) {
                        curr = claims.sublist(0, 10);
                        print(curr);
                      } else {
                        curr = claims;
                        print(claims);
                      }
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
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Server.....');
                    var pendClaims = await fdb.FirebaseDB.getFilteredClaims(
                        this.widget.feedType, 'Pending', context);
                    print(pendClaims);
                    setState(() {
                      claims = pendClaims;
                      if (claims.length > 10) {
                        curr = claims.sublist(0, 10);
                        print(curr);
                      } else {
                        curr = claims;
                        print(claims);
                      }
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
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: ()async{
                    _loadingDialog('Getting Data from Server.....');
                    var pendClaims = await fdb.FirebaseDB.getFilteredClaims(
                        this.widget.feedType, 'Rejected', context);
                    setState(() {
                      claims = pendClaims;
                      if (claims.length > 10) {
                        curr = claims.sublist(0, 10);
                        print(curr);
                      } else {
                        curr = claims;
                        print(curr);
                      }
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
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: ()async{
                    _loadingDialog('Getting Data from Server.....');
                    var pendClaims = await fdb.FirebaseDB.getFilteredClaims(
                        this.widget.feedType, 'True', context);
                    setState(() {
                      claims = pendClaims;
                      if (claims.length > 10) {
                        curr = claims.sublist(0, 10);
                        print(curr);
                      } else {
                        curr = claims;
                        print(curr);
                      }
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

  _getData() async {
    claims = await fdb.FirebaseDB.getClaims(this.widget.feedType, context);
    setState(() {
      if (claims.length > 10) {
        curr = claims.sublist(0, 10);
        print(curr);
      } else {
        curr = claims;
        print(curr);
      }
      isLoading = false;
    });
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
          ? _loadingScreen('Getting Data from Server.....')
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
                  top: 10 + Globals.height * 2 / 33,
                  right: Globals.width / 55,
                  child: Row(
                    children: [
                      Text('Feed: ' +
                          (this.widget.feedType ? 'Image' : 'Video')),
                      Switch(
                        activeColor: Colors.blueGrey,
                        value: this.widget.feedType,
                        onChanged: (value) {
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(builder: (context) {
                            return ManageClaims(value);
                          }));
                        },
                      )
                    ],
                  ),
                ),
                Positioned(
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
                Positioned(
                    top: Globals.getHeight(150),
                    left: Globals.getWidth(300),
                    child: Container(
                      height: Globals.getHeight(500),
                      width: Globals.getWidth(1250),
                      child: Card(
                        elevation: 12,
                        child: SingleChildScrollView(
                          child: DataTable(
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'Requested By',
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
                                    'News',
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
                                    'Fact Check',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                              rows: List.generate(curr.length, (index) {
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(GestureDetector(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: curr[index].isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                curr[index].isSelected = value;
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
                                          Text(curr[index].requestedBy)
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return Claim(curr[index].claimId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(curr[index].date),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return Claim(curr[index].claimId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(curr[index].news),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return Claim(curr[index].claimId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(curr[index].status),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return Claim(curr[index].claimId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(curr[index].factCheck),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return Claim(curr[index].claimId);
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
                    top: Globals.getHeight(650),
                    left: Globals.getWidth(300),
                    child: Row(
                      children: [
                        Checkbox(
                          value: allSelected,
                          onChanged: (value) {
                            setState(() {
                              allSelected = value;
                              claims.forEach((element) {
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
                  top: Globals.getHeight(675),
                  left: (Globals.width ~/ 2) -
                      ((claims.length ~/ 10) >= 10
                          ? Globals.getWidth(415) / 2
                          : ((2 + claims.length ~/ 10) * Globals.getWidth(30) +
                                  (1 + claims.length ~/ 10) * 5) /
                              2),
                  child: Row(
                    children: [
                      Container(
                        height: Globals.getHeight(30),
                        width: Globals.getWidth(30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[350]),
                        child: TextButton(
                          onPressed: () {
                            selectedPage > 1
                                ? setState(() {
                                    selectedPage -= 1;
                                    curr = claims.sublist(
                                        (selectedPage - 1) * 10,
                                        selectedPage * 10);
                                    // ignore: unnecessary_statements
                                  })
                                : null;
                          },
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        child: Stack(
                          children:
                              List.generate(1 + (claims.length ~/ 10), (index) {
                            return Row(
                              children: [
                                Container(
                                  height: Globals.getHeight(30),
                                  width: Globals.getWidth(30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: selectedPage == 1
                                        ? Color(0xFFEF233C)
                                        : Colors.grey[350],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedPage = 1;
                                      });
                                    },
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                          color: selectedPage == 1
                                              ? Colors.white
                                              : Colors.grey[600]),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      Container(
                        height: Globals.getHeight(30),
                        width: Globals.getWidth(30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[350]),
                        child: TextButton(
                          onPressed: () {
                            selectedPage < 6
                                ? setState(() {
                                    selectedPage += 1;
                                    curr = claims.sublist(selectedPage * 10,
                                        (selectedPage + 1) * 10);
                                    // ignore: unnecessary_statements
                                  })
                                : null;
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: Globals.getHeight(720),
                    left: Globals.getWidth(1200),
                    child: Row(
                      children: [
                        Container(
                          height: Globals.getHeight(40),
                          width: Globals.getWidth(170),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFF343434)),
                          child: TextButton(
                            onPressed: () {
                              var val = 1;
                              _loadingDialog('Rejecting Claims.....');
                              claims.forEach((element) async {
                                if (element.isSelected) {
                                  await fdb.FirebaseDB.rejectClaim(
                                      element.claimId);
                                }
                              });
                              Navigator.pop(context);
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(builder: (context) {
                                return ManageClaims(true);
                              }));
                            },
                            child: Text(
                              'Reject',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: (30),
                        ),
                        Container(
                          height: Globals.getHeight(40),
                          width: Globals.getWidth(170),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFF5A5A5A)),
                          child: TextButton(
                            onPressed: () {
                              _loadingDialog('Approving Claims.....');
                              claims.forEach((element) async {
                                if (element.isSelected) {
                                  await fdb.FirebaseDB.approveClaim(
                                          element.claimId);
                                }
                              });
                              Navigator.pop(context);
                              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                                return ManageClaims(this.widget.feedType);
                              }));
                            },
                            child: Text(
                              'Approve',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
    );
  }
}
