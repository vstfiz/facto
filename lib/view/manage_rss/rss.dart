import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/view/manage_rss/manage_rss.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class RSS extends StatefulWidget{
  final String rssId;

  RSS(this.rssId);

  @override
  _RSSState createState()=> _RSSState();
}

class _RSSState extends State<RSS>{
  bool isLoading = true;
  TextEditingController _commentController = new TextEditingController();
  var rss = [];
  String status;
  @override
  void initState() {
    super.initState();
    _getData();
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

  _getData()async{
    rss = await fdb.FirebaseDB.getRSSFromId(this.widget.rssId).whenComplete((){
      setState(() {
        isLoading = false;
      });
    });
    status = rss[3];
    print(rss.length);
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
      backgroundColor: Color(0xFFE5E5E5),
      body: isLoading?_loadingScreen('Getting Data from Servers.....'):Stack(
        children: [
          Positioned(
            child: TopBar(),
            top: 0.0,
          ),
          Positioned(
            child: SecondaryTopBar(new Text('RSS Posts')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(
              top: 5 + Globals.height * 2 / 33,
              left: 20 + Globals.width / 6,
              child: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                    return ManageRSS();
                  }));
                },
              )),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
              top: 200,
              left: 400,
              child: Container(
                height: 450,
                width: 800,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(right:10,child: Container(child:
                    DropdownButton<String>(
                      value: status,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String newValue) {
                        setState(() {
                          status = newValue;
                        });
                        print(status);
                      },
                      items: <String>['Rejected', 'True', 'Pending']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                    )
                    ),
                    Positioned(
                      top: 50,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Source',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 500,
                            height: 30,
                            child: Text(
                              rss[0],
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Url  ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 500,
                            height: 30,
                            child: Text(
                              rss[1],
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Description',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 400,
                            height: 80,
                            child: Text(
                              rss[2],
                              style:
                              TextStyle(fontFamily: 'Livvic', fontSize: 20,),softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Positioned(
                      top: 260,
                      left: 40,
                      child: Row(
                        children: [
                          Text('Comment', style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                            width: 400,
                            height: 30,
                            child: TextField(
                              controller: _commentController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              style: TextStyle(fontFamily: 'Livvic'),
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  contentPadding: EdgeInsets.only(bottom: 10.0)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(top: 200,
                        left: 600,
                        child: IconButton(
                          icon: Icon(Icons.image_outlined), iconSize: 150,)),
                    Positioned(
                        top: 400,
                        left: 600,
                        child: Container(
                          height: 30,
                          width: 170,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xFF5A5A5A)),
                          child: TextButton(
                            onPressed: () async{
                              _loadingDialog('Uploading Data...');
                              await fdb.FirebaseDB.updateRSS(_commentController.text,status,this.widget.rssId);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Save',
                              style:
                              TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}