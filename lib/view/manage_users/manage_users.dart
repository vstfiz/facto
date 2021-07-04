import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManageUsers extends StatefulWidget{
  _ManageUsersState createState()=> _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers>{
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
            top: 150,
            left: 400,
            child: Text(
              'Hi, ${Globals.user.name}',
              style: TextStyle(
                  fontFamily: 'Livvic', color: Color(0xFFA90015), fontSize: 20),
            ),
          ),
          Positioned(
            top: 250,
            left: 750,
            child: Text(
              'Manage Admins',
              style: TextStyle(
                  fontFamily: 'Livvic', color: Colors.black, fontSize: 20),
            ),
          ),
          Positioned(
            top: 150,
            left: 1200,
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xFF5A5A5A)),
              child: TextButton(
                child: Text(
                  'Create User',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
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
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'User',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Role Assigned',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'RSS',
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
                        DataColumn(
                          label: Text(
                            '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(Globals.user.name)),
                            DataCell(Text(
                                'Admin')),
                            DataCell(Text('10')),
                            DataCell(Text('03')),
                            DataCell(IconButton(
                              icon: Icon(Icons.settings),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(Globals.user.name)),
                            DataCell(Text(
                                'Editor')),
                            DataCell(Text('10')),
                            DataCell(Text('13')),
                            DataCell(IconButton(
                              icon: Icon(Icons.settings),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(Globals.user.name)),
                            DataCell(Text(
                                'Author')),
                            DataCell(Text('100')),
                            DataCell(Text('03')),
                            DataCell(IconButton(
                              icon: Icon(Icons.settings),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(Globals.user.name)),
                            DataCell(Text(
                                'Partner')),
                            DataCell(Text('50')),
                            DataCell(Text('63')),
                            DataCell(IconButton(
                              icon: Icon(Icons.settings),
                            )),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text(Globals.user.name)),
                            DataCell(Text(
                                'Admin')),
                            DataCell(Text('10')),
                            DataCell(Text('03')),
                            DataCell(IconButton(
                              icon: Icon(Icons.settings),
                            )),
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