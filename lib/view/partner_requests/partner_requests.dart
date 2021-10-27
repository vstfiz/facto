import 'package:facto/model/claims.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/view/partner_requests/request.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class PartnerRequests extends StatefulWidget {
  final bool feedType;

  PartnerRequests(this.feedType);

  @override
  _PartnerRequestsState createState() => _PartnerRequestsState();
}

class _PartnerRequestsState extends State<PartnerRequests> {
  var selectedPage = 1;
  bool allSelected = false;
  var claims =
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
        right: Globals.getWidth(300),
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
                    var allClaims = await fdb.FirebaseDB.getPartnerRequests(
                        this.widget.feedType, context);
                    print(allClaims);
                    setState(() {
                      claims = allClaims;
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
                    var pendClaims = await fdb.FirebaseDB.getFilteredPartnerRequests(
                        this.widget.feedType, 'Pending', context);
                    print(pendClaims);
                    setState(() {
                      claims = pendClaims;
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
                  onPressed: () async {
                    _loadingDialog('Getting Data from Server.....');
                    var pendClaims = await fdb.FirebaseDB.getFilteredPartnerRequests(
                        this.widget.feedType, 'Rejected', context);
                    setState(() {
                      claims = pendClaims;
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
                margin: EdgeInsets.symmetric(vertical: Globals.getHeight(10)),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Server.....');
                    var pendClaims = await fdb.FirebaseDB.getFilteredPartnerRequests(
                        this.widget.feedType, 'True', context);
                    setState(() {
                      claims = pendClaims;
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
    claims = await fdb.FirebaseDB.getPartnerRequests(this.widget.feedType, context);
    setState(() {
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
                  child: SecondaryTopBar(new Text('Partner Requests')),
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
                            return PartnerRequests(value);
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
                                    'Claim By',
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
                              ],
                              rows: List.generate(claims.length, (index) {
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(GestureDetector(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: claims[index].isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                claims[index].isSelected =
                                                    value;
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
                                          Text(claims[index].requestedBy)
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return Request(claims[index].claimId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(claims[index].news),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return Request(claims[index].claimId);
                                        }));
                                      },
                                    )),
                                    DataCell(GestureDetector(
                                      child: Text(claims[index].status),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                          return Request(claims[index].claimId);
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
                    top: Globals.getHeight(720),
                    left: Globals.getWidth(1300),
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
                              _loadingDialog('Approving Claims.....');
                              claims.forEach((element) async {
                                if (element.isSelected) {
                                  await fdb.FirebaseDB.approvePartnerRequest(
                                      element.claimId);
                                }
                              });
                              Navigator.pop(context);
                              Navigator.of(context).pushReplacement(
                                  new MaterialPageRoute(builder: (context) {
                                return PartnerRequests(this.widget.feedType);
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
