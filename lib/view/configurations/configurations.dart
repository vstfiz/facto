import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Config extends StatefulWidget{
  _ConfigState createState()=> _ConfigState();
}

class _ConfigState extends State<Config>{
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
            child: SecondaryTopBar(new Text('Configuration')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
            top: Globals.height * 81 / 495,
            left: Globals.width / 3,
            child: Column(
              children: [
                Text('Add Categories',style: TextStyle(
                  fontSize: 20
                ),),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 600,
                  child: TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder()
                    ),
                  ),
                )
              ],
            ),

          ),
          Positioned(
            top: 250,
            left: 1000,
            child: Container(
              height: 35,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xFF5A5A5A)),
              child: TextButton(
                child: Text(
                  'Submit',
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
                      columns:  <DataColumn>[
                        DataColumn(
                          label: Text(
                            '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        DataColumn(
                          label: Center(
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
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
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Technology')),
                            DataCell(Text(
                                'Sports')),
                            DataCell(Text('Games')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Country')),
                            DataCell(Text(
                                'Music')),
                            DataCell(Text('')),
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