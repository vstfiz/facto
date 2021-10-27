import 'package:facto/model/ads.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/view/create_ads/create_ads.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class AdData extends StatefulWidget{
  @override
  _AdDataState createState() => _AdDataState();
}

class _AdDataState extends State<AdData>{
  bool allSelected = false;
  var ads =
  List.filled(0, new Ads('', '', 0,true,''), growable: true);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }


  _getData() async {
    ads = await fdb.FirebaseDB.getAds(context);
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
            child: SecondaryTopBar(new Text('Ads Data')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(
              left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
            top: Globals.height * 81 / 495,
            left: Globals.width / 10,
            child: Container(
              padding: EdgeInsets.only(left: Globals.height / 5),
              width: Globals.width * 5 / 6,
              height: Globals.height / 10,
              child: Row(
                children: [
                  Container(
                      height: Globals.getHeight(40),
                      width: Globals.height / 5,
                      decoration: BoxDecoration(
                          color: Color(0xFF1E7D34),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                            'Active Ads',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Livvic'),
                          ),
                        ),
                      ),
                  SizedBox(
                    width: Globals.width / 20,
                  ),
                  Container(
                      height: Globals.getHeight(40),
                      width: Globals.height / 5,
                      decoration: BoxDecoration(
                          color: Color(0xFF128799),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                            'Ads this month',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
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
              top: Globals.getHeight(200),
              left: Globals.getWidth(300),
              child: Container(
                height: Globals.getHeight(450),
                width: Globals.getWidth(1250),
                child: Card(
                  elevation: 12,
                  child: SingleChildScrollView(
                    child: DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Client',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Active Ads',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Impressions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                              label: Text(
                                    'Admin',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                ),
                        ],
                        rows: List.generate(ads.length, (index) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(ads[index].client),),
                              DataCell(Text(ads[index].value),),
                              DataCell(Text(ads[index].impression.toString()),),
                              DataCell(Text(ads[index].createdBy),),

                            ],
                          );
                        })),
                  ),
                ),
              )),
          Positioned(top:Globals.getHeight(680),right:Globals.getWidth(100),child:
          Container(
            height: Globals.getHeight(50),
            width: Globals.getWidth(170),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xFF5A5A5A)),
            child: TextButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){
                  return CreateAds();
                }));
              },
              child: Text(
                'Create Ads',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),)
        ],
      ),
    );
  }
}