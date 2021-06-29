import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProdFeeds extends StatefulWidget {
  _ProdFeedState createState() => _ProdFeedState();
}

class _ProdFeedState extends State<ProdFeeds> {
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
            child: SecondaryTopBar(new Text('Prod Feeds')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
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
                      Text('Feed: Video'),
                      Switch(value: true, onChanged: null)
                    ],
                  ),
                  Row(
                    children: [
                      Text('Feed: English'),
                      Switch(value: false, onChanged: null)
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
                          label: Row(
                            children: [
                              Text(
                                'Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              IconButton(icon: Icon(Icons.filter_alt), onPressed: null)
                            ],
                          )
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
                              IconButton(icon: Icon(Icons.filter_alt), onPressed: null)
                            ],
                          )
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
                      rows:  <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Lorem ipsum dolor sit amet')),
                            DataCell(Text('Facto')),
                            DataCell(Text('12/02/20')),
                            DataCell(Text('Active')),
                            DataCell(Text('12')),
                            DataCell(Text(
                                '5')),
                            DataCell(IconButton(icon: Icon(Icons.settings),)),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Lorem ipsum dolor sit amet')),
                            DataCell(Text('Facto')),
                            DataCell(Text('12/02/20')),
                            DataCell(Text('Active')),
                            DataCell(Text('12')),
                            DataCell(Text(
                                '5')),
                            DataCell(IconButton(icon: Icon(Icons.settings),)),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Lorem ipsum dolor sit amet')),
                            DataCell(Text('Facto')),
                            DataCell(Text('12/02/20')),
                            DataCell(Text('Active')),
                            DataCell(Text('12')),
                            DataCell(Text(
                                '5')),
                            DataCell(IconButton(icon: Icon(Icons.settings),)),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Lorem ipsum dolor sit amet')),
                            DataCell(Text('Facto')),
                            DataCell(Text('12/02/20')),
                            DataCell(Text('Active')),
                            DataCell(Text('12')),
                            DataCell(Text(
                                '5')),
                            DataCell(IconButton(icon: Icon(Icons.settings),)),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Lorem ipsum dolor sit amet')),
                            DataCell(Text('Facto')),
                            DataCell(Text('12/02/20')),
                            DataCell(Text('Active')),
                            DataCell(Text('12')),
                            DataCell(Text(
                                '5')),
                            DataCell(IconButton(icon: Icon(Icons.settings),)),
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
