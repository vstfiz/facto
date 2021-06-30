import 'package:facto/model/claims.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'claim.dart';

class ManageClaims extends StatefulWidget {
  _ManageClaimsState createState() => _ManageClaimsState();
}

class _ManageClaimsState extends State<ManageClaims> {
  var selectedPage = 1;
  bool allSelected = false;
  var claims = [
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
    new Claims(
        'Mr. Facto',
        '12/02/2020',
        'lorem ipsum fvgrer gfvergregerg sdfgregferg',
        'Pending',
        'Admin Admin 1',
        false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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

          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
              top: 150,
              left: 300,
              child: Container(
                height: 500,
                width: 1250,
                child: Card(
                  elevation: 12,
                  child: SingleChildScrollView(
                    child: DataTable(
                        columns: const <DataColumn>[
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
                            label: Text(
                              'Status',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Fact Check',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
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
                                          claims[index].isSelected = value;
                                        });
                                      },
                                      checkColor: Color(0xFF00A424),
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>((states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Colors.white;
                                        }
                                        return null;
                                      }),
                                    ),
                                    Text(claims[index].requestedBy)
                                  ],
                                ),
                                onTap: () {},
                              )),
                              DataCell(GestureDetector(
                                child: Text(claims[index].date),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return Claim(
                                        'dwf',
                                        'fewef',
                                        'fewefew',
                                        'fewfwe',
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consequat, ipsum cras lorem molestie. Viverra suspendisse urna, lacus in in. Quis sapien non enim morbi cras. Pellentesque ultricies ultricies commodo ornare adipiscing eget platea enim faucibus. Massa vitae faucibus ornare adipiscing aenean egestas euismod gravida. ',
                                        'fewfwefewfewfc');
                                  }));
                                },
                              )),
                              DataCell(GestureDetector(
                                child: Text(claims[index].news),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return Claim(
                                        'dwf',
                                        'fewef',
                                        'fewefew',
                                        'fewfwe',
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consequat, ipsum cras lorem molestie. Viverra suspendisse urna, lacus in in. Quis sapien non enim morbi cras. Pellentesque ultricies ultricies commodo ornare adipiscing eget platea enim faucibus. Massa vitae faucibus ornare adipiscing aenean egestas euismod gravida. ',
                                        'fewfwefewfewfc');
                                  }));
                                },
                              )),
                              DataCell(GestureDetector(
                                child: Text(claims[index].status),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return Claim(
                                        'dwf',
                                        'fewef',
                                        'fewefew',
                                        'fewfwe',
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consequat, ipsum cras lorem molestie. Viverra suspendisse urna, lacus in in. Quis sapien non enim morbi cras. Pellentesque ultricies ultricies commodo ornare adipiscing eget platea enim faucibus. Massa vitae faucibus ornare adipiscing aenean egestas euismod gravida. ',
                                        'fewfwefewfewfc');
                                  }));
                                },
                              )),
                              DataCell(GestureDetector(
                                child: Text(claims[index].factCheck),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return Claim(
                                        'dwf',
                                        'fewef',
                                        'fewefew',
                                        'fewfwe',
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consequat, ipsum cras lorem molestie. Viverra suspendisse urna, lacus in in. Quis sapien non enim morbi cras. Pellentesque ultricies ultricies commodo ornare adipiscing eget platea enim faucibus. Massa vitae faucibus ornare adipiscing aenean egestas euismod gravida. ',
                                        'fewfwefewfewfc');
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
              top: 650,
              left: 300,
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
                    fillColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
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
              top: 675,
              left: Globals.width / 2,
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[350]),
                    child: TextButton(
                      onPressed: () {
                        selectedPage > 1
                            ? setState(() {
                                selectedPage -= 1;
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
                    height: 30,
                    width: 30,
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
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedPage == 2
                          ? Color(0xFFEF233C)
                          : Colors.grey[350],
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = 2;
                        });
                      },
                      child: Text(
                        '2',
                        style: TextStyle(
                            color: selectedPage == 2
                                ? Colors.white
                                : Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedPage == 3
                          ? Color(0xFFEF233C)
                          : Colors.grey[350],
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = 3;
                        });
                      },
                      child: Text(
                        '3',
                        style: TextStyle(
                            color: selectedPage == 3
                                ? Colors.white
                                : Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedPage == 4
                          ? Color(0xFFEF233C)
                          : Colors.grey[350],
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = 4;
                        });
                      },
                      child: Text(
                        '4',
                        style: TextStyle(
                            color: selectedPage == 4
                                ? Colors.white
                                : Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedPage == 5
                          ? Color(0xFFEF233C)
                          : Colors.grey[350],
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = 5;
                        });
                      },
                      child: Text(
                        '5',
                        style: TextStyle(
                            color: selectedPage == 5
                                ? Colors.white
                                : Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedPage == 6
                          ? Color(0xFFEF233C)
                          : Colors.grey[350],
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = 6;
                        });
                      },
                      child: Text(
                        '6',
                        style: TextStyle(
                            color: selectedPage == 6
                                ? Colors.white
                                : Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[350]),
                    child: TextButton(
                      onPressed: () {
                        selectedPage < 6
                            ? setState(() {
                                selectedPage += 1;
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
              )),
          Positioned(
              top: 720,
              left: 1200,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xFF343434)),
                    child: TextButton(
                      child: Text(
                        'Reject',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 40,
                    width: 170,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xFF5A5A5A)),
                    child: TextButton(
                      child: Text(
                        'Approve',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
