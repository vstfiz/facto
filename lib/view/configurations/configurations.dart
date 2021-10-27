import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facto/model/category.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:oktoast/oktoast.dart';
import 'dart:html' as html;
import 'package:firebase/firebase.dart' as fb;
import 'package:facto/model/rss_urls.dart';


class Config extends StatefulWidget {
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  TextEditingController _categoryController = new TextEditingController();
  TextEditingController _geoController = new TextEditingController();
  TextEditingController _rssController = new TextEditingController();
  var category = List.filled(0, Category('', ''), growable: true);
  var rss = List.filled(0, RSSUrls('', '', new Timestamp.now()), growable: true);
  var geo = [];
  bool isCategory = true;
  bool isRss = false;
  bool isGeo = false;
  html.File _image;

  Future<String> _uploadImage(html.File image) async {
    fb.StorageReference storageRef = fb.storage().ref('images/${Globals.getRandString(10)}');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
    await storageRef.put(image).future;
    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    return imageUri.toString();
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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    category = await fdb.FirebaseDB.getCategory(context).whenComplete(() async {
      geo = await fdb.FirebaseDB.getGeo(context).whenComplete(() async {
        rss = await fdb.FirebaseDB.getRSSUrls(context).whenComplete(() async {
          setState(() {
            isLoading = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? _loadingScreen('Getting Data from Servers.....')
          : isCategory
              ? categoryStack(context)
              : isGeo
                  ? geoStack(context)
                  : rssStack(context),
    );
  }

  Widget categoryStack(BuildContext context) {
    return OKToast(
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
        Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
        Positioned(
          top: Globals.height * 81 / 495,
          left: Globals.width / 3,
          child: Row(
            children: [
              TextButton(onPressed: (){
                if(!isCategory){
                  setState(() {
                    isCategory = true;
                    isGeo = false;
                    isRss = false;
                  });
                }
              }, child: Text('Category')),
              SizedBox(width: Globals.getWidth(250),),
              TextButton(onPressed: (){
                if(!isGeo){
                  setState(() {
                    isGeo = true;
                    isCategory = false;
                    isRss = false;
                  });
                }
              }, child: Text('Geo')),
              SizedBox(width: Globals.getWidth(250),),
              TextButton(onPressed: (){
                if(!isRss){
                  setState(() {
                    isRss = true;
                    isCategory = false;
                    isGeo = false;
                  });
                }
              }, child: Text('RSS')),
            ],
          )
        ),
        Positioned(
          top: Globals.height * 100 / 495,
          left: Globals.width / 4.2,
          child: _image == null
              ? IconButton(
            onPressed: () async {
              try {
                html.File picked =
                await ImagePickerWeb.getImage(
                    outputType:
                    ImageType.file);
                setState(() {
                  _image = picked;
                });
              } catch (e) {
                setState(() {
                  showToast(
                    e,
                    position:
                    ToastPosition.bottom,
                    backgroundColor:
                    Color(0xFF5A5A5A),
                    radius: 8.0,
                    textStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white),
                  );
                });
              }
            },
            icon: Icon(Icons.image_outlined),
            iconSize: Globals.getWidth(100),
            color: Colors.grey,
          )
              : Container(
            padding: EdgeInsets.only(
                top: Globals.getHeight(50),
                bottom: Globals.getHeight(30),
                right: Globals.getWidth(20),
                left: Globals.getWidth(50)),
            child: Text(
              'Image Selected!',
              style: TextStyle(color: Colors.red),
            ),
          )
        ),
        Positioned(
          top: Globals.height * 112 / 495,
          left: Globals.width / 3,
          child: Text(
            'Add Category',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Positioned(
            top: Globals.height * 100 / 495,
            left: Globals.width / 3 + 150,
            child: SizedBox(
              width: Globals.getWidth(600),
              child: TextField(
                controller: _categoryController,
                decoration: InputDecoration(border: UnderlineInputBorder()),
              ),
            )),
        Positioned(
          top: Globals.getHeight(250),
          left: Globals.getWidth(1000),
          child: Container(
            height: Globals.getHeight(35),
            width: Globals.getWidth(150),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xFF5A5A5A)),
            child: TextButton(
              onPressed: () async {
                if (_categoryController.text != null &&
                    _categoryController.text.trim() != '') {
                  if(_image!= null){
                    _loadingDialog('Adding Category');
                    String uploadedImageUrl =
                    await _uploadImage(_image);
                    await fdb.FirebaseDB.addCategory(
                        _categoryController.text,uploadedImageUrl, context);
                    setState(() {
                      category.add(new Category(_categoryController.text, uploadedImageUrl));
                      Navigator.pop(context);
                      setState(() {
                        _image = null;
                      });
                      _categoryController.clear();
                    });
                  }
                  else{
                    setState(() {
                      showToast(
                        'Please Select Category Image',
                        position: ToastPosition.bottom,
                        backgroundColor: Color(0xFF5A5A5A),
                        radius: 8.0,
                        textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                      );
                    });
                  }
                } else {
                  setState(() {
                    showToast(
                      'Invalid Category Name',
                      position: ToastPosition.bottom,
                      backgroundColor: Color(0xFF5A5A5A),
                      radius: 8.0,
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
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
            top: Globals.getHeight(300),
            left: Globals.getWidth(400),
            child: Container(
              height: Globals.getHeight(400),
              width: Globals.getWidth(900),
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
                      rows:
                          List.generate((category.length / 3).ceil(), (index) {
                        if (category.length % 3 == 0) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Row(children: [Text(category[3 * index].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[3 * index].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt(3 * index);
                                  });
                                });
                              })],)),
                              DataCell(Row(children: [Text(category[(3 * index) + 1].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[(3 * index) + 1].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt((3 * index) + 1);
                                  });
                                });
                              })],)),
                              DataCell(Row(children: [Text(category[(3 * index) + 2].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[(3 * index) + 2].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt((3 * index) + 2);
                                  });
                                });
                              })],)),
                            ],
                          );
                        } else if (category.length % 3 == 1) {
                          if (index == category.length ~/ 3) {
                            return DataRow(cells: [
                              DataCell(Row(children: [Text(category[3 * index].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[3 * index].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt(3 * index);
                                  });
                                });
                              })],)),
                              DataCell(Text(' ')),
                              DataCell(Text(' ')),
                            ]);
                          } else {
                            return DataRow(cells: [
                              DataCell(Row(children: [Text(category[3 * index].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[3 * index].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt(3 * index);
                                  });
                                });
                              })],)),
                              DataCell(Row(children: [Text(category[(3 * index) + 1].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[(3 * index) + 1].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt((3 * index) + 1);
                                  });
                                });
                              })],)),
                              DataCell(Row(children: [Text(category[(3 * index) + 2].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[(3 * index) + 2].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt((3 * index) + 2);
                                  });
                                });
                              })],)),
                            ]);
                          }
                        } else {
                          if (index == category.length ~/ 3) {
                            return DataRow(cells: [
                              DataCell(Row(children: [Text(category[3 * index].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[3 * index].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt(3 * index);
                                  });
                                });
                              })],)),
                              DataCell(Row(children: [Text(category[(3 * index) + 1].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[(3 * index) + 1].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt((3 * index) + 1);
                                  });
                                });
                              })],)),
                              DataCell(Text(' ')),
                            ]);
                          } else {
                            return DataRow(cells: [
                              DataCell(Row(children: [Text(category[3 * index].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[3 * index].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt(3 * index);
                                  });
                                });
                              })],)),
                              DataCell(Row(children: [Text(category[(3 * index) + 1].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[(3 * index) + 1].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt((3 * index) + 1);
                                  });
                                });
                              })],)),
                              DataCell(Row(children: [Text(category[(3 * index) + 2].name),SizedBox(width: 20,),IconButton(icon: Icon(Icons.clear), onPressed: ()async{
                                await fdb.FirebaseDB.removeCategory(category[(3 * index) + 2].name, context).whenComplete(() {
                                  setState(() {
                                    category.removeAt((3 * index) + 2);
                                  });
                                });
                              })],),)
                            ]);
                          }
                        }
                      })),
                ),
              ),
            )),
      ],
    ));
  }

  Widget geoStack(BuildContext context) {
    return OKToast(
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
            Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
            Positioned(
                top: Globals.height * 81 / 495,
                left: Globals.width / 3,
                child: Row(
                  children: [
                    TextButton(onPressed: (){
                      if(!isCategory){
                        setState(() {
                          isCategory = true;
                          isGeo = false;
                          isRss = false;
                        });
                      }
                    }, child: Text('Category')),
                    SizedBox(width: Globals.getWidth(250),),
                    TextButton(onPressed: (){
                      if(!isGeo){
                        setState(() {
                          isGeo = true;
                          isCategory = false;
                          isRss = false;
                        });
                      }
                    }, child: Text('Geo')),
                    SizedBox(width: Globals.getWidth(250),),
                    TextButton(onPressed: (){
                      if(!isRss){
                        setState(() {
                          isRss = true;
                          isCategory = false;
                          isGeo = false;
                        });
                      }
                    }, child: Text('RSS')),
                  ],
                )
            ),
            Positioned(
              top: Globals.height * 112 / 495,
              left: Globals.width / 3,
              child: Text(
                'Add Geo',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Positioned(
                top: Globals.height * 100 / 495,
                left: Globals.width / 3 + 150,
                child: SizedBox(
                  width: Globals.getWidth(600),
                  child: TextField(
                    controller: _geoController,
                    decoration: InputDecoration(border: UnderlineInputBorder()),
                  ),
                )),
            Positioned(
              top: Globals.getHeight(250),
              left: Globals.getWidth(1000),
              child: Container(
                height: Globals.getHeight(35),
                width: Globals.getWidth(150),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xFF5A5A5A)),
                child: TextButton(
                  onPressed: () async {
                    if (_geoController.text != null &&
                        _geoController.text.trim() != '') {
                        await fdb.FirebaseDB.addGeo(
                            _geoController.text, context);
                        setState(() {
                          geo.add(_geoController.text);
                          _geoController.clear();
                        });

                    } else {
                      setState(() {
                        showToast(
                          'Invalid Category Name',
                          position: ToastPosition.bottom,
                          backgroundColor: Color(0xFF5A5A5A),
                          radius: 8.0,
                          textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
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
                top: Globals.getHeight(300),
                left: Globals.getWidth(400),
                child: Container(
                  height: Globals.getHeight(400),
                  width: Globals.getWidth(900),
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
                                  'Geo',
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
                          rows:
                          List.generate((geo.length / 3).ceil(), (index) {
                            if (geo.length % 3 == 0) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(geo[3 * index])),
                                  DataCell(Text(geo[(3 * index) + 1])),
                                  DataCell(Text(geo[(3 * index) + 2])),
                                ],
                              );
                            } else if (geo.length % 3 == 1) {
                              if (index == geo.length ~/ 3) {
                                return DataRow(cells: [
                                  DataCell(Text(geo[3 * index])),
                                  DataCell(Text(' ')),
                                  DataCell(Text(' ')),
                                ]);
                              } else {
                                return DataRow(cells: [
                                  DataCell(Text(geo[3 * index])),
                                  DataCell(Text(geo[(3 * index) + 1])),
                                  DataCell(Text(geo[(3 * index) + 2])),
                                ]);
                              }
                            } else {
                              if (index == geo.length ~/ 3) {
                                return DataRow(cells: [
                                  DataCell(Text(geo[3 * index])),
                                  DataCell(Text(geo[(3 * index) + 1])),
                                  DataCell(Text(' ')),
                                ]);
                              } else {
                                return DataRow(cells: [
                                  DataCell(Text(geo[3 * index])),
                                  DataCell(Text(geo[(3 * index) + 1])),
                                  DataCell(Text(geo[(3 * index) + 2])),
                                ]);
                              }
                            }
                          })),
                    ),
                  ),
                )),
          ],
        ));
  }

  Widget rssStack(BuildContext context) {
    return OKToast(
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
            Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
            Positioned(
                top: Globals.height * 81 / 495,
                left: Globals.width / 3,
                child: Row(
                  children: [
                    TextButton(onPressed: (){
                      if(!isCategory){
                        setState(() {
                          isCategory = true;
                          isGeo = false;
                          isRss = false;
                        });
                      }
                    }, child: Text('Category')),
                    SizedBox(width: Globals.getWidth(250),),
                    TextButton(onPressed: (){
                      if(!isGeo){
                        setState(() {
                          isGeo = true;
                          isCategory = false;
                          isRss = false;
                        });
                      }
                    }, child: Text('Geo')),
                    SizedBox(width: Globals.getWidth(250),),
                    TextButton(onPressed: (){
                      if(!isRss){
                        setState(() {
                          isRss = true;
                          isCategory = false;
                          isGeo = false;
                        });
                      }
                    }, child: Text('RSS')),
                  ],
                )
            ),
            Positioned(
              top: Globals.height * 112 / 495,
              left: Globals.width / 3,
              child: Text(
                'Add RSS Urls',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Positioned(
                top: Globals.height * 100 / 495,
                left: Globals.width / 3 + 150,
                child: SizedBox(
                  width: Globals.getWidth(600),
                  child: TextField(
                    controller: _rssController,
                    decoration: InputDecoration(border: UnderlineInputBorder()),
                  ),
                )),
            Positioned(
              top: Globals.getHeight(250),
              left: Globals.getWidth(1000),
              child: Container(
                height: Globals.getHeight(35),
                width: Globals.getWidth(150),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xFF5A5A5A)),
                child: TextButton(
                  onPressed: () async {
                    if (_rssController.text != null &&
                        _rssController.text.trim() != '') {
                      await fdb.FirebaseDB.addRSSUrl(
                          _rssController.text, context);
                      setState(() {
                        rss.add(new RSSUrls(_rssController.text,'Unlock',Timestamp.now()));
                        _rssController.clear();
                      });

                    } else {
                      setState(() {
                        showToast(
                          'Invalid URl',
                          position: ToastPosition.bottom,
                          backgroundColor: Color(0xFF5A5A5A),
                          radius: 8.0,
                          textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
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
                top: Globals.getHeight(300),
                left: Globals.getWidth(400),
                child: Container(
                  height: Globals.getHeight(400),
                  width: Globals.getWidth(900),
                  child: Card(
                    elevation: 12,
                    child: SingleChildScrollView(
                      child: DataTable(
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Urls',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ),
                            DataColumn(
                              label: Center(
                                child: Text(
                                  'Status',
                                  style: TextStyle(
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
                          rows:
                          List.generate(rss.length, (index) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(rss[index].url)),
                                  rss[index].status == 'Unlock'?DataCell(Text(rss[index].status)):DataCell(Text(rss[index].status.toString() + ' , ' + rss[index].time.toDate().year.toString() + '/' + rss[index].time.toDate().month.toString() + '/' + rss[index].time.toDate().day.toString())),
                                  DataCell(ElevatedButton(onPressed: ()async{
                                    if(rss[index].status == 'Lock'){
                                      await fdb.FirebaseDB.lockUrl(context, rss[index].url, 'Unlock').whenComplete(() {
                                        setState(() {
                                          rss[index].status = 'Unlock';
                                        });
                                      });
                                    }
                                    else{
                                      DateTime dt = DateTime.now();
                                      DateTime dt1 = DateTime.utc(dt.year,dt.month==12?1:dt.month+1,dt.day);
                                      await fdb.FirebaseDB.lockUrl(context, rss[index].url, 'Lock').whenComplete(() {
                                        setState(() {
                                          rss[index].status = 'Lock';
                                          rss[index].time = Timestamp.fromDate(dt1);
                                        });
                                      });
                                    }
                                  },child: Text(rss[index].status == 'Lock'?'Unlock':'Lock'),)),
                                ],
                              );
                          })),
                    ),
                  ),
                )),
          ],
        ));
  }
// Widget categoryStack(BuildContext context){
//   return OKToast(
//       child: Stack(
//         children: [
//           Positioned(
//             child: TopBar(),
//             top: 0.0,
//           ),
//           Positioned(
//             child: SecondaryTopBar(new Text('Configuration')),
//             top: Globals.height * 2 / 33,
//             right: 0.0,
//           ),
//           Positioned(
//               left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
//           Positioned(
//             top: Globals.height * 81 / 495,
//             left: Globals.width / 3,
//             child: Column(
//               children: [
//                 Text(
//                   'Add Categories',
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   width: 600,
//                   child: TextField(
//                     controller: _categoryController,
//                     decoration:
//                     InputDecoration(border: UnderlineInputBorder()),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Positioned(
//             top: 250,
//             left: 1000,
//             child: Container(
//               height: 35,
//               width: 150,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   color: Color(0xFF5A5A5A)),
//               child: TextButton(
//                 onPressed: () async{
//                   if (_categoryController.text != null &&
//                       _categoryController.text.trim() != '') {
//                     await fdb.FirebaseDB.addCategory(_categoryController.text, context);
//                     setState(() {
//                       category.add(new Category(_categoryController.text, 'url'));
//                       _categoryController.clear();
//                     });
//                   } else {
//                     setState(() {
//                       showToast(
//                         'Invalid Category Name',
//                         position: ToastPosition.bottom,
//                         backgroundColor: Color(0xFF5A5A5A),
//                         radius: 8.0,
//                         textStyle: TextStyle(
//                             fontSize: 18.0, color: Colors.white),
//                       );
//                     });
//                   }
//                 },
//                 child: Text(
//                   'Submit',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//               top: 300,
//               left: 400,
//               child: Container(
//                 height: 400,
//                 width: 900,
//                 child: Card(
//                   elevation: 12,
//                   child: SingleChildScrollView(
//                     child: DataTable(
//                         columns: <DataColumn>[
//                           DataColumn(
//                             label: Text(
//                               '',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Center(
//                               child: Text(
//                                 'Categories',
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey),
//                               ),
//                             ),
//                           ),
//                           DataColumn(
//                             label: Text(
//                               '',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                         ],
//                         rows: List.generate((category.length / 3).ceil(),
//                                 (index) {
//                               if (category.length % 3 == 0) {
//                                 return DataRow(
//                                   cells: <DataCell>[
//                                     DataCell(Text(category[3 * index].name)),
//                                     DataCell(
//                                         Text(category[(3 * index) + 1].name)),
//                                     DataCell(
//                                         Text(category[(3 * index) + 2].name)),
//                                   ],
//                                 );
//                               } else if (category.length % 3 == 1) {
//                                 if (index == category.length ~/ 3) {
//                                   return DataRow(cells: [
//                                     DataCell(Text(category[3 * index].name)),
//                                     DataCell(Text(' ')),
//                                     DataCell(Text(' ')),
//                                   ]);
//                                 } else {
//                                   return DataRow(cells: [
//                                     DataCell(Text(category[3 * index].name)),
//                                     DataCell(
//                                         Text(category[(3 * index) + 1].name)),
//                                     DataCell(
//                                         Text(category[(3 * index) + 2].name)),
//                                   ]);
//                                 }
//                               } else {
//                                 if (index == category.length ~/ 3) {
//                                   return DataRow(cells: [
//                                     DataCell(Text(category[3 * index].name)),
//                                     DataCell(
//                                         Text(category[(3 * index) + 1].name)),
//                                     DataCell(Text(' ')),
//                                   ]);
//                                 } else {
//                                   return DataRow(cells: [
//                                     DataCell(Text(category[3 * index].name)),
//                                     DataCell(
//                                         Text(category[(3 * index) + 1].name)),
//                                     DataCell(
//                                         Text(category[(3 * index) + 2].name)),
//                                   ]);
//                                 }
//                               }
//                             })),
//                   ),
//                 ),
//               )),
//         ],
//       ));
// }
}
