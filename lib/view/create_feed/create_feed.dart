import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:facto/model/category.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:language_pickers/language_picker_dropdown.dart';
import 'package:language_pickers/languages.dart';
import 'package:facto/database/firebase_db.dart' as fdb;
import 'package:oktoast/oktoast.dart';
import 'package:universal_html/html.dart' as html;
import 'package:firebase/firebase.dart' as fb;

class CreateFeed extends StatefulWidget {
  bool feedType;

  CreateFeed(this.feedType);

  _CreateFeedState createState() => _CreateFeedState();
}

class _CreateFeedState extends State<CreateFeed> {
  TextEditingController _claimController = new TextEditingController();
  TextEditingController _truthController = new TextEditingController();
  TextEditingController _urlController = new TextEditingController();
  TextEditingController _tagsController = new TextEditingController();
  var tags = [];
  List<String> geo = [];
  String language;
  var category = List.filled(0, Category('', ''), growable: true);
  bool isLoading = true;
  String selectedCategory;
  html.File _image;
  String claimId;
  String uploadedImageUrl;
  String country;
  int charRemain = 500;
  ScrollController _scrollController = new ScrollController();

  initState() {
    super.initState();
    claimId = Globals.getRandString(15);
    _getData();
  }

  Future<String> _uploadImage(html.File image, String imageName) async {
    fb.StorageReference storageRef = fb.storage().ref('images/$imageName');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageRef.put(image).future;
    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    return imageUri.toString();
  }

  Future<void> _submitDialog1(String value) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              content: Container(
                  height: Globals.getHeight(60),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: Globals.getWidth(40),
                        ),
                        SizedBox(
                          width: Globals.getWidth(20),
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
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(builder: (context) {
                        return CreateFeed(this.widget.feedType);
                      }));
                    },
                    child: Text(
                      'Dismiss',
                      style: TextStyle(color: Colors.blueGrey),
                    ))
              ],
            ));
  }

  Future<void> _submitDialog(String value) {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              content: Container(
                  height: Globals.getHeight(60),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: Globals.getWidth(40),
                        ),
                        SizedBox(
                          width: Globals.getWidth(20),
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
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Dismiss',
                      style: TextStyle(color: Colors.blueGrey),
                    ))
              ],
            ));
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

  _getData() async {
    category = await fdb.FirebaseDB.getCategory(context).whenComplete(() async {
      geo = await fdb.FirebaseDB.getGeo(context).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    });
    selectedCategory = category[0].name;
  }

  Widget _buildDropdownItem(Language language) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 8.0,
        ),
        Text("${language.name} (${language.isoCode})"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
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
                  child: SecondaryTopBar(new Text('Form')),
                  top: Globals.height * 2 / 33,
                  right: 0.0,
                ),
                Positioned(
                  top: 10 + Globals.height * 2 / 33,
                  right: Globals.width / 55,
                  child: Row(
                    children: [
                      Text('Feed: ' +
                          (this.widget.feedType ? 'Image' : 'Video')),
                      Switch(
                        activeColor: Colors.blueGrey,
                        value: this.widget.feedType,
                        onChanged: (value) {
                          setState(() {
                            this.widget.feedType = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: Globals.getHeight(120),
                  left: Globals.getWidth(400),
                  child: Text(
                    'Hi, ${Globals.user.name}',
                    style: TextStyle(
                        fontFamily: 'Livvic',
                        color: Color(0xFFA90015),
                        fontSize: 20),
                  ),
                ),
                Positioned(
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
                Positioned(
                    left: Globals.getWidth(400),
                    bottom: 0.0,
                    child: Container(
                      height: Globals.getHeight(610),
                      width: Globals.getWidth(900),
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          this.widget.feedType
                              ?
                          // Positioned(
                          //         top: Globals.getHeight(170),
                          //         left: Globals.getWidth(400),
                          //         child:
                                  Container(
                                    height: Globals.getHeight(750),
                                    width: Globals.getWidth(900),
                                    color: Colors.white,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          child: Text(
                                            'Create Feed',
                                            style: TextStyle(fontSize: 24),
                                          ),
                                          top: Globals.getHeight(10),
                                          left: Globals.getWidth(50),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(50),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Claim',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    width: Globals.getWidth(500),
                                                    child: TextField(
                                                      controller:
                                                          _claimController,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          charRemain = 500 -
                                                              (value.length +
                                                                  _truthController
                                                                      .text
                                                                      .length);
                                                        });
                                                      },
                                                      style: TextStyle(
                                                          fontFamily: 'Livvic'),
                                                      minLines: 1,
                                                      maxLines: 3,
                                                      decoration:
                                                          InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width:
                                                                        2.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(charRemain.toString() +
                                                      ' characters remaining'),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(180),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Truth ',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    width: Globals.getWidth(500),
                                                    child: TextField(
                                                      controller:
                                                          _truthController,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          charRemain = 500 -
                                                              (value.length +
                                                                  _claimController
                                                                      .text
                                                                      .length);
                                                        });
                                                      },
                                                      style: TextStyle(
                                                          fontFamily: 'Livvic'),
                                                      minLines: 1,
                                                      maxLines: 3,
                                                      decoration:
                                                          InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width:
                                                                        2.0)),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(charRemain.toString() +
                                                      ' characters remaining'),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(310),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Urls    ',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              SizedBox(
                                                width: Globals.getWidth(400),
                                                height: Globals.getHeight(50),
                                                child: TextField(
                                                  controller: _urlController,
                                                  style: TextStyle(
                                                      fontFamily: 'Livvic'),
                                                  minLines: 1,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.green,
                                                            width: 2.0)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(380),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Tags  ',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              SizedBox(
                                                  width: Globals.getWidth(350),
                                                  height: Globals.getHeight(60),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: Globals.getWidth(350),
                                                        height: Globals.getHeight(50),
                                                        child: TextField(
                                                          controller:
                                                              _tagsController,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Livvic'),
                                                          decoration:
                                                              InputDecoration(
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .green,
                                                                    width:
                                                                        2.0)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Globals.getHeight(10),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: Globals.getWidth(20),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFFEF233C),
                                                        width: 1.0)),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      tags.add(
                                                          _tagsController.text);
                                                      _tagsController.clear();
                                                    });
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFEF233C)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(440),
                                          left: Globals.getWidth(140),
                                          child: Container(
                                            height: Globals.getHeight(50),
                                            width: Globals.getWidth(400),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate(
                                                    tags.length, (index) {
                                                  return Container(
                                                    height: Globals.getHeight(30),
                                                    child: Card(
                                                      elevation: 12,
                                                      color: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            tags[index],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          IconButton(
                                                              iconSize: 15,
                                                              icon: Icon(
                                                                  Icons.clear),
                                                              color: Colors.red,
                                                              onPressed: () {
                                                                setState(() {
                                                                  tags.removeAt(
                                                                      index);
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(490),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Language',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(15),
                                              ),
                                              SizedBox(
                                                width: Globals.getWidth(400),
                                                height: Globals.getHeight(30),
                                                child: LanguagePickerDropdown(
                                                  languagesList: [
                                                    {
                                                      "isoCode": "en",
                                                      "name": "English"
                                                    },
                                                    {
                                                      "isoCode": "hi",
                                                      "name": "Hindi"
                                                    },
                                                  ],
                                                  onValuePicked: (value) {
                                                    setState(() {
                                                      language = value.name;
                                                      print(value.name);
                                                    });
                                                  },
                                                  itemBuilder:
                                                      _buildDropdownItem,
                                                  initialValue: 'en',
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(560),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Geo   ',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              SizedBox(
                                                  width: Globals.getWidth(450),
                                                  height: Globals.getHeight(30),
                                                  child: DropdownButton<String>(
                                                    value: country,
                                                    icon: const Icon(Icons
                                                        .arrow_drop_down_sharp),
                                                    iconSize: Globals.getWidth(24),
                                                    hint: Text('Select Geo'),
                                                    underline: SizedBox(),
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Livvic',
                                                        fontSize: 20),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        country = newValue;
                                                      });
                                                      print(selectedCategory);
                                                    },
                                                    items: geo.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(630),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Category',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(20),
                                              ),
                                              SizedBox(
                                                  width: Globals.getWidth(450),
                                                  height: Globals.getHeight(30),
                                                  child: DropdownButton<String>(
                                                    value: selectedCategory,
                                                    icon: const Icon(Icons
                                                        .arrow_drop_down_sharp),
                                                    iconSize: Globals.getWidth(24),
                                                    hint:
                                                        Text('Select Category'),
                                                    underline: SizedBox(),
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Livvic',
                                                        fontSize: 20),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        selectedCategory =
                                                            newValue;
                                                      });
                                                      print(selectedCategory);
                                                    },
                                                    items: category.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (Category value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value.name,
                                                        child: Text(
                                                          value.name,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            top: Globals.getHeight(700),
                                            left: Globals.getWidth(700),
                                            child: Container(
                                              height: Globals.getHeight(30),
                                              width: Globals.getWidth(170),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: Color(0xFF5A5A5A)),
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (_claimController.text !=
                                                          null &&
                                                      _claimController.text
                                                              .trim() !=
                                                          '') {
                                                    if (_truthController.text !=
                                                            null &&
                                                        _truthController.text
                                                                .trim() !=
                                                            '') {
                                                      if (_urlController.text !=
                                                              null &&
                                                          _urlController.text
                                                                  .trim() !=
                                                              '') {
                                                        if (tags.length != 0) {
                                                          if (language !=
                                                                  null &&
                                                              language.trim() !=
                                                                  '') {
                                                            if (country !=
                                                                    null &&
                                                                country.trim() !=
                                                                    '') {
                                                              if (selectedCategory !=
                                                                      null &&
                                                                  selectedCategory
                                                                          .trim() !=
                                                                      '') {
                                                                if (_image !=
                                                                    null) {
                                                                  _loadingDialog(
                                                                      'Creating Feed....');
                                                                  await fdb.FirebaseDB.createFeed(
                                                                      _claimController
                                                                          .text,
                                                                      _truthController
                                                                          .text,
                                                                      _urlController
                                                                          .text,
                                                                      tags,
                                                                      country,
                                                                      language,
                                                                      selectedCategory,
                                                                      uploadedImageUrl,
                                                                      claimId,
                                                                      this
                                                                          .widget
                                                                          .feedType,
                                                                      context);

                                                                  Navigator.pop(
                                                                      context);
                                                                  _submitDialog1(
                                                                      'Feed Successfully Created');
                                                                } else {
                                                                  setState(() {
                                                                    showToast(
                                                                      'No Image Selected. Select a valid image and upload it.',
                                                                      position:
                                                                          ToastPosition
                                                                              .bottom,
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xFF5A5A5A),
                                                                      radius:
                                                                          8.0,
                                                                      textStyle: TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                          color:
                                                                              Colors.white),
                                                                    );
                                                                  });
                                                                }
                                                              } else {
                                                                setState(() {
                                                                  showToast(
                                                                    'Select a valid value in Category.',
                                                                    position:
                                                                        ToastPosition
                                                                            .bottom,
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xFF5A5A5A),
                                                                    radius: 8.0,
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        color: Colors
                                                                            .white),
                                                                  );
                                                                });
                                                              }
                                                            } else {
                                                              setState(() {
                                                                showToast(
                                                                  'Select a valid value in Geographical Location.',
                                                                  position:
                                                                      ToastPosition
                                                                          .bottom,
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFF5A5A5A),
                                                                  radius: 8.0,
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      color: Colors
                                                                          .white),
                                                                );
                                                              });
                                                            }
                                                          } else {
                                                            setState(() {
                                                              showToast(
                                                                'Select a valid value in Language.',
                                                                position:
                                                                    ToastPosition
                                                                        .bottom,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF5A5A5A),
                                                                radius: 8.0,
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .white),
                                                              );
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            showToast(
                                                              'Fill in atleast 1 tag',
                                                              position:
                                                                  ToastPosition
                                                                      .bottom,
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFF5A5A5A),
                                                              radius: 8.0,
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          });
                                                        }
                                                      } else {
                                                        setState(() {
                                                          showToast(
                                                            'Enter valid value in Url field.',
                                                            position:
                                                                ToastPosition
                                                                    .bottom,
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF5A5A5A),
                                                            radius: 8.0,
                                                            textStyle: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Colors
                                                                    .white),
                                                          );
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        showToast(
                                                          'Enter valid value in Truth field.',
                                                          position:
                                                              ToastPosition
                                                                  .bottom,
                                                          backgroundColor:
                                                              Color(0xFF5A5A5A),
                                                          radius: 8.0,
                                                          textStyle: TextStyle(
                                                              fontSize: 18.0,
                                                              color:
                                                                  Colors.white),
                                                        );
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      showToast(
                                                        'Enter valid value in Claim field.',
                                                        position: ToastPosition
                                                            .bottom,
                                                        backgroundColor:
                                                            Color(0xFF5A5A5A),
                                                        radius: 8.0,
                                                        textStyle: TextStyle(
                                                            fontSize: 18.0,
                                                            color:
                                                                Colors.white),
                                                      );
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'Submit For Review',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )),
                                        Positioned(
                                          top: Globals.getHeight(330),
                                          left: Globals.getWidth(750),
                                          child: Container(
                                            width: Globals.getWidth(80),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: Color(0xFFA90015),
                                                    width: 1.0)),
                                            child: TextButton(
                                              onPressed: () async {
                                                _loadingDialog(
                                                    'Uploading Image.....');
                                                uploadedImageUrl =
                                                    await _uploadImage(
                                                        _image, claimId);
                                                Navigator.pop(context);
                                                _submitDialog('Image Uploaded');
                                              },
                                              child: Text(
                                                'Upload',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFFA90015)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: Globals.getHeight(150),
                                            left: Globals.getWidth(700),
                                            height: Globals.getHeight(120),
                                            width: Globals.getWidth(200),
                                            child: _image == null
                                                ? IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        html.File picked =
                                                            await ImagePickerWeb
                                                                .getImage(
                                                                    outputType:
                                                                        ImageType
                                                                            .file);
                                                        setState(() {
                                                          _image = picked;
                                                        });
                                                      } catch (e) {
                                                        setState(() {
                                                          showToast(
                                                            e,
                                                            position:
                                                                ToastPosition
                                                                    .bottom,
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF5A5A5A),
                                                            radius: 8.0,
                                                            textStyle: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Colors
                                                                    .white),
                                                          );
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                        Icons.image_outlined),
                                                    iconSize: Globals.getWidth(150),
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
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ))
                                      ],
                                    ),
                                  )
                // )
                              :
                          // Positioned(
                          //         top: Globals.getHeight(200),
                          //         left: Globals.getWidth(400),
                          //         child:
                                  Container(
                                    height: Globals.getHeight(500),
                                    width: Globals.getWidth(900),
                                    color: Colors.white,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: Globals.getHeight(50),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Claim',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              SizedBox(
                                                width: Globals.getWidth(500),
                                                height: Globals.getHeight(90),
                                                child: TextField(
                                                  controller: _claimController,
                                                  style: TextStyle(
                                                      fontFamily: 'Livvic'),
                                                  minLines: 1,
                                                  maxLines: 3,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: Globals.getHeight(10)),
                                                    border: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(150),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Truth',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              SizedBox(
                                                width: Globals.getWidth(500),
                                                height: Globals.getHeight(90),
                                                child: TextField(
                                                  controller: _truthController,
                                                  style: TextStyle(
                                                      fontFamily: 'Livvic'),
                                                  minLines: 1,
                                                  maxLines: 3,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: Globals.getHeight(10)),
                                                    border: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(250),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Youtube Url',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              SizedBox(
                                                width: Globals.getWidth(500),
                                                height: Globals.getHeight(30),
                                                child: TextField(
                                                  controller: _urlController,
                                                  style: TextStyle(
                                                      fontFamily: 'Livvic'),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: Globals.getHeight(10)),
                                                    border: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(300),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Tags  ',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              SizedBox(
                                                  width: Globals.getWidth(350),
                                                  height: Globals.getHeight(40),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: Globals.getWidth(350),
                                                        height: Globals.getHeight(30),
                                                        child: TextField(
                                                          controller:
                                                              _tagsController,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Livvic'),
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: Globals.getHeight(10)),
                                                            border: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width:
                                                                        2.0)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Globals.getHeight(10),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: Globals.getWidth(20),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFFEF233C),
                                                        width: 1.0)),
                                                child: TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      tags.add(
                                                          _tagsController.text);
                                                      _tagsController.clear();
                                                    });
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFEF233C)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(350),
                                          left: Globals.getWidth(140),
                                          child: Container(
                                            height: Globals.getHeight(50),
                                            width: Globals.getWidth(400),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: List.generate(
                                                    tags.length, (index) {
                                                  return Container(
                                                    height: Globals.getHeight(30),
                                                    child: Card(
                                                      elevation: 12,
                                                      color: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            tags[index],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          IconButton(
                                                              iconSize: 15,
                                                              icon: Icon(
                                                                  Icons.clear),
                                                              color: Colors.red,
                                                              onPressed: () {
                                                                setState(() {
                                                                  tags.removeAt(
                                                                      index);
                                                                });
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(400),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Geo   ',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(50),
                                              ),
                                              SizedBox(
                                                width: Globals.getWidth(475),
                                                height: Globals.getHeight(30),
                                                child: CountryCodePicker(
                                                  onChanged: (value) {
                                                    country = value.name;
                                                    print(value.code);
                                                  },
                                                  initialSelection: 'IN',
                                                  showCountryOnly: true,
                                                  alignLeft: true,
                                                  showOnlyCountryWhenClosed:
                                                      true,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: Globals.getHeight(450),
                                          left: Globals.getWidth(40),
                                          child: Row(
                                            children: [
                                              Text('Category',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                width: Globals.getWidth(20),
                                              ),
                                              SizedBox(
                                                  width: Globals.getWidth(450),
                                                  height: Globals.getHeight(30),
                                                  child: DropdownButton<String>(
                                                    value: selectedCategory,
                                                    icon: const Icon(Icons
                                                        .arrow_drop_down_sharp),
                                                    iconSize: Globals.getWidth(24),
                                                    hint:
                                                        Text('Select Category'),
                                                    underline: SizedBox(),
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Livvic',
                                                        fontSize: 20),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        selectedCategory =
                                                            newValue;
                                                      });
                                                      print(selectedCategory);
                                                    },
                                                    items: category.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (Category value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value.name,
                                                        child: Text(
                                                          value.name,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            top: Globals.getHeight(450),
                                            left: Globals.getWidth(700),
                                            child: Container(
                                              height: Globals.getHeight(40),
                                              width: Globals.getWidth(170),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: Color(0xFF5A5A5A)),
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (_claimController.text !=
                                                          null &&
                                                      _claimController.text
                                                              .trim() !=
                                                          '') {
                                                    if (_urlController.text !=
                                                            null &&
                                                        _urlController.text
                                                                .trim() !=
                                                            '') {
                                                      if (tags.length != 0) {
                                                        if (country != null &&
                                                            country.trim() !=
                                                                '') {
                                                          if (selectedCategory !=
                                                                  null &&
                                                              selectedCategory
                                                                      .trim() !=
                                                                  '') {
                                                            if (_truthController
                                                                    .text
                                                                    .trim() !=
                                                                '') {
                                                              if (_image !=
                                                                  null) {
                                                                _loadingDialog(
                                                                    'Creating Feed....');
                                                                await fdb.FirebaseDB.createVideoFeed(
                                                                    _claimController
                                                                        .text,
                                                                    _truthController
                                                                        .text,
                                                                    _urlController
                                                                        .text,
                                                                    tags,
                                                                    country,
                                                                    selectedCategory,
                                                                    uploadedImageUrl,
                                                                    claimId,
                                                                    this
                                                                        .widget
                                                                        .feedType,
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                _submitDialog1(
                                                                    'Feed Successfully Created');
                                                              } else {
                                                                setState(() {
                                                                  showToast(
                                                                    'No Image Selected. Select a valid image and upload it.',
                                                                    position:
                                                                        ToastPosition
                                                                            .bottom,
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xFF5A5A5A),
                                                                    radius: 8.0,
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        color: Colors
                                                                            .white),
                                                                  );
                                                                });
                                                              }
                                                            } else {
                                                              setState(() {
                                                                showToast(
                                                                  'Select a valid value in Truth Field.',
                                                                  position:
                                                                      ToastPosition
                                                                          .bottom,
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFF5A5A5A),
                                                                  radius: 8.0,
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      color: Colors
                                                                          .white),
                                                                );
                                                              });
                                                            }
                                                          } else {
                                                            setState(() {
                                                              showToast(
                                                                'Select a valid value in Category.',
                                                                position:
                                                                    ToastPosition
                                                                        .bottom,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF5A5A5A),
                                                                radius: 8.0,
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .white),
                                                              );
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            showToast(
                                                              'Select a valid value in Geographical Location.',
                                                              position:
                                                                  ToastPosition
                                                                      .bottom,
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFF5A5A5A),
                                                              radius: 8.0,
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .white),
                                                            );
                                                          });
                                                        }
                                                      } else {
                                                        setState(() {
                                                          showToast(
                                                            'Fill in atleast 1 tag',
                                                            position:
                                                                ToastPosition
                                                                    .bottom,
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF5A5A5A),
                                                            radius: 8.0,
                                                            textStyle: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Colors
                                                                    .white),
                                                          );
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        showToast(
                                                          'Enter valid value in Url field.',
                                                          position:
                                                              ToastPosition
                                                                  .bottom,
                                                          backgroundColor:
                                                              Color(0xFF5A5A5A),
                                                          radius: 8.0,
                                                          textStyle: TextStyle(
                                                              fontSize: 18.0,
                                                              color:
                                                                  Colors.white),
                                                        );
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      showToast(
                                                        'Enter valid value in Summary field.',
                                                        position: ToastPosition
                                                            .bottom,
                                                        backgroundColor:
                                                            Color(0xFF5A5A5A),
                                                        radius: 8.0,
                                                        textStyle: TextStyle(
                                                            fontSize: 18.0,
                                                            color:
                                                                Colors.white),
                                                      );
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'Submit For Review',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )),
                                        Positioned(
                                            top: Globals.getHeight(270),
                                            left: Globals.getWidth(750),
                                            child: Container(
                                              width: Globals.getWidth(90),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                      color: Color(0xFFA90015),
                                                      width: 1.0)),
                                              child: TextButton(
                                                onPressed: () async {
                                                  _loadingDialog(
                                                      'Uploading Image.....');
                                                  uploadedImageUrl =
                                                      await _uploadImage(
                                                          _image, claimId);
                                                  Navigator.pop(context);
                                                  _submitDialog(
                                                      'Image Uploaded');
                                                },
                                                child: Text(
                                                  'Upload Thumbnail',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFFA90015)),
                                                ),
                                              ),
                                            )),
                                        Positioned(
                                            top: Globals.getHeight(120),
                                            left: Globals.getWidth(700),
                                            height: Globals.getHeight(120),
                                            width: Globals.getWidth(200),
                                            child: _image == null
                                                ? IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        html.File picked =
                                                            await ImagePickerWeb
                                                                .getImage(
                                                                    outputType:
                                                                        ImageType
                                                                            .file);
                                                        setState(() {
                                                          _image = picked;
                                                        });
                                                      } catch (e) {
                                                        setState(() {
                                                          showToast(
                                                            e,
                                                            position:
                                                                ToastPosition
                                                                    .bottom,
                                                            backgroundColor:
                                                                Color(
                                                                    0xFF5A5A5A),
                                                            radius: 8.0,
                                                            textStyle: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Colors
                                                                    .white),
                                                          );
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                        Icons.image_outlined),
                                                    iconSize: Globals.getWidth(150),
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
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ))
                                      ],
                                    ),
                                  )
    // )
                        ],
                      ),
                    ))
              ],
            )),
    );
  }
}
