import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            child: SecondaryTopBar(new Text('DashBoard')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
            top: Globals.height * 81 / 495,
            left: Globals.width / 6,
            child: Container(
              padding: EdgeInsets.only(left: Globals.height / 5),
              width: Globals.width * 5 / 6,
              height: Globals.height / 10,
              child: Row(
                children: [
                  Container(
                      height: 100,
                      width: Globals.height / 5,
                      decoration: BoxDecoration(
                          color: Color(0xFF1E7D34),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Total Open RSS Feeds',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Livvic'),
                        ),
                      )),
                  SizedBox(
                    width: Globals.width / 20,
                  ),
                  Container(
                    height: 100,
                    width: Globals.height / 5,
                    decoration: BoxDecoration(
                        color: Color(0xFF128799),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Total Open Claims',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Livvic'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Globals.width / 20,
                  ),
                  Container(
                      height: 100,
                      width: Globals.height / 5,
                      decoration: BoxDecoration(
                          color: Color(0xFFE6B00E),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Total Pending Feed Review',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Livvic'),
                        ),
                      )),
                  SizedBox(
                    width: Globals.width / 20,
                  ),
                  Container(
                    height: 100,
                    width: Globals.height / 5,
                    decoration: BoxDecoration(
                        color: Color(0xFFBF2E3C),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Total production Feeds(Hindi/Eng)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Livvic'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 1000,
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 40,
                  child: Center(
                    child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: TextButton(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.filter_alt,
                                  color: Color(0xFFFF4669),
                                ),
                                Text(
                                  'Filter',
                                  style: TextStyle(color: Color(0xFFFF4669)),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 115,
                  height: 40,
                  child: Center(
                    child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: TextButton(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Color(0xFFFF4669),
                                ),
                                Text(
                                  'Calendar',
                                  style: TextStyle(color: Color(0xFFFF4669)),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 300,
              left: 400,
              child: Container(
                height: 400,
                width: 900,
                child: Card(
                  elevation: 12,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Admin',
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
                          label: Text(
                            'Fact Check',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Mr. Admin Admin 1')),
                            DataCell(Text(
                                'Lorem ipsum dolor sit amet, consectetur consec...')),
                            DataCell(Text('05')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Mr. Admin Admin 1')),
                            DataCell(Text(
                                'Lorem ipsum dolor sit amet, consectetur consec...')),
                            DataCell(Text('05')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Mr. Admin Admin 1')),
                            DataCell(Text(
                                'Lorem ipsum dolor sit amet, consectetur consec...')),
                            DataCell(Text('05')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Mr. Admin Admin 1')),
                            DataCell(Text(
                                'Lorem ipsum dolor sit amet, consectetur consec...')),
                            DataCell(Text('05')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Mr. Admin Admin 1')),
                            DataCell(Text(
                                'Lorem ipsum dolor sit amet, consectetur consec...')),
                            DataCell(Text('05')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Mr. Admin Admin 1')),
                            DataCell(Text(
                                'Lorem ipsum dolor sit amet, consectetur consec...')),
                            DataCell(Text('05')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Mr. Admin Admin 1')),
                            DataCell(Text(
                                'Lorem ipsum dolor sit amet, consectetur consec...')),
                            DataCell(Text('05')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Mr. Admin Admin 1')),
                            DataCell(Text(
                                'Lorem ipsum dolor sit amet, consectetur consec...')),
                            DataCell(Text('05')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
