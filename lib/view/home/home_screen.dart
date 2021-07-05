import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto/model/claims.dart';
import 'package:facto/model/user.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class HomeScreen extends StatefulWidget {
  final bool feedType;

  HomeScreen(this.feedType);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  DateTime selectedDate;
  bool isLoading = true;
  var feed = List.filled(0, new User.forHome('', 0, 0), growable: true);

  _getData() async {
    feed = await fdb.FirebaseDB.getFeedForHome(this.widget.feedType, context)
        .whenComplete(() {
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
    {
      selectedDate = picked;
      String time = picked.toString().substring(0,10).replaceAll('-', '');
      _loadingDialog('Getting Data from Servers.....');
      var timeFeed = await (fdb.FirebaseDB.getFeedForHomeWithDate(time, context));
      setState(() {
        feed = timeFeed;
      });
      Navigator.pop(context);
    }

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
                  child: SecondaryTopBar(new Text('DashBoard')),
                  top: Globals.height * 2 / 33,
                  right: 0.0,
                ),
                Positioned(
                  top: 10 + Globals.height * 2 / 33,
                  right: Globals.width / 55,
                  child: Row(
                    children: [
                      Text('Feed: ' +
                          (this.widget.feedType == true ? 'Image' : 'Video')),
                      Switch(
                        activeColor: Colors.blueGrey,
                        value: this.widget.feedType,
                        onChanged: (value) {
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(builder: (context) {
                            return HomeScreen(value);
                          }));
                        },
                      )
                    ],
                  ),
                ),
                Positioned(
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
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
                        width: 130,
                        height: 40,
                        child: Center(
                          child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: Color(0xFFFF4669),
                                      ),
                                      FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: SizedBox(
                                            child: AutoSizeText(
                                              selectedDate==null?'Calendar':selectedDate.toString().substring(0,11),
                                              style:
                                              TextStyle(color: Color(0xFFFF4669)),
                                              maxLines: 1,
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ),
                      SizedBox(width: 10,),
                      selectedDate!=null?Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                              return HomeScreen(true);
                            }));
                          },
                          child: Icon(Icons.clear,color: Colors.white,),
                        ),
                      ):SizedBox()
                    ],
                  )
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
                              rows: List.generate(feed.length, (index) {
                                return DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(feed[index].name)),
                                    DataCell(Text(feed[index].feeds.toString())),
                                    DataCell(Text(feed[index].factCheck.toString())),
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
