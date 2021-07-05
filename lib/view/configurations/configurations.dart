import 'package:facto/model/category.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;
import 'package:oktoast/oktoast.dart';

class Config extends StatefulWidget {
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  TextEditingController _categoryController = new TextEditingController();
  var category = List.filled(0, Category('', false, ''), growable: true);

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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    category = await fdb.FirebaseDB.getCategory(context).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? _loadingScreen('Getting Data from Servers.....')
          : OKToast(
              child: Stack(
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
                Positioned(
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
                Positioned(
                  top: Globals.height * 81 / 495,
                  left: Globals.width / 3,
                  child: Column(
                    children: [
                      Text(
                        'Add Categories',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 600,
                        child: TextField(
                          controller: _categoryController,
                          decoration:
                              InputDecoration(border: UnderlineInputBorder()),
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
                      onPressed: () async{
                        if (_categoryController.text != null &&
                            _categoryController.text.trim() != '') {
                          await fdb.FirebaseDB.addCategory(_categoryController.text, context);
                          setState(() {
                            category.add(new Category(_categoryController.text, false, 'url'));
                            _categoryController.clear();
                          });
                        } else {
                          setState(() {
                            showToast(
                              'Invalid Category Name',
                              position: ToastPosition.bottom,
                              backgroundColor: Color(0xFF5A5A5A),
                              radius: 8.0,
                              textStyle: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            );
                          });
                        }
                      },
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
                              columns: <DataColumn>[
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
                              rows: List.generate((category.length / 3).ceil(),
                                  (index) {
                                if (category.length % 3 == 0) {
                                  return DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(category[3 * index].name)),
                                      DataCell(
                                          Text(category[(3 * index) + 1].name)),
                                      DataCell(
                                          Text(category[(3 * index) + 2].name)),
                                    ],
                                  );
                                } else if (category.length % 3 == 1) {
                                  if (index == category.length ~/ 3) {
                                    return DataRow(cells: [
                                      DataCell(Text(category[3 * index].name)),
                                      DataCell(Text(' ')),
                                      DataCell(Text(' ')),
                                    ]);
                                  } else {
                                    return DataRow(cells: [
                                      DataCell(Text(category[3 * index].name)),
                                      DataCell(
                                          Text(category[(3 * index) + 1].name)),
                                      DataCell(
                                          Text(category[(3 * index) + 2].name)),
                                    ]);
                                  }
                                } else {
                                  if (index == category.length ~/ 3) {
                                    return DataRow(cells: [
                                      DataCell(Text(category[3 * index].name)),
                                      DataCell(
                                          Text(category[(3 * index) + 1].name)),
                                      DataCell(Text(' ')),
                                    ]);
                                  } else {
                                    return DataRow(cells: [
                                      DataCell(Text(category[3 * index].name)),
                                      DataCell(
                                          Text(category[(3 * index) + 1].name)),
                                      DataCell(
                                          Text(category[(3 * index) + 2].name)),
                                    ]);
                                  }
                                }
                              })),
                        ),
                      ),
                    )),
              ],
            )),
    );
  }
}
