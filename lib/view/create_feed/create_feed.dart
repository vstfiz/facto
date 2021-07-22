import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:facto/model/category.dart';
import 'package:facto/util/globals.dart';
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
  String language;
  var category = List.filled(0, Category('', false, ''), growable: true);
  bool isLoading = true;
  String selectedCategory;
  html.File _image;
  String claimId;
  String uploadedImageUrl;
  String country;

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
                  height: 60,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 40,
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
                  height: 60,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 40,
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

  _getData() async {
    category = await fdb.FirebaseDB.getCategory(context).whenComplete(() {
      setState(() {
        isLoading = false;
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
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
                Positioned(
                  top: 150,
                  left: 400,
                  child: Text(
                    'Hi, ${Globals.user.name}',
                    style: TextStyle(
                        fontFamily: 'Livvic',
                        color: Color(0xFFA90015),
                        fontSize: 20),
                  ),
                ),
                this.widget.feedType
                    ? Positioned(
                        top: 200,
                        left: 400,
                        child: Container(
                          height: 550,
                          width: 900,
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Positioned(
                                child: Text(
                                  'Create Feed',
                                  style: TextStyle(fontSize: 24),
                                ),
                                top: 10,
                                left: 50,
                              ),
                              Positioned(
                                top: 50,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Claim',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 500,
                                      height: 30,
                                      child: TextField(
                                        controller: _claimController,
                                        style: TextStyle(fontFamily: 'Livvic'),
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
                                top: 100,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Truth ',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 500,
                                      height: 30,
                                      child: TextField(
                                        controller: _truthController,
                                        style: TextStyle(fontFamily: 'Livvic'),
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
                                top: 150,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Urls    ',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 400,
                                      height: 30,
                                      child: TextField(
                                        controller: _urlController,
                                        style: TextStyle(fontFamily: 'Livvic'),
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
                                top: 200,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Tags  ',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                        width: 350,
                                        height: 40,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 350,
                                              height: 30,
                                              child: TextField(
                                                controller: _tagsController,
                                                style: TextStyle(
                                                    fontFamily: 'Livvic'),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.green,
                                                          width: 2.0)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Color(0xFFEF233C),
                                              width: 1.0)),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            tags.add(_tagsController.text);
                                            _tagsController.clear();
                                          });
                                        },
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                              color: Color(0xFFEF233C)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 230,
                                left: 140,
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children:
                                          List.generate(tags.length, (index) {
                                        return Container(
                                          height: 30,
                                          child: Card(
                                            elevation: 12,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  tags[index],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                IconButton(
                                                    iconSize: 15,
                                                    icon: Icon(Icons.clear),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        tags.removeAt(index);
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
                                top: 290,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Language',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 400,
                                      height: 30,
                                      child: LanguagePickerDropdown(
                                        onValuePicked: (value) {
                                          setState(() {
                                            language = value.name;
                                            print(value.name);
                                          });
                                        },
                                        itemBuilder: _buildDropdownItem,
                                        initialValue: 'en',
                                      ),
                                      //     TextField(
                                      //   style: TextStyle(fontFamily: 'Livvic'),
                                      //   decoration: InputDecoration(
                                      //     border: OutlineInputBorder(
                                      //         borderSide: BorderSide(
                                      //             color: Colors.green, width: 2.0)),
                                      //   ),
                                      // )
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 340,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Geo   ',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 475,
                                      height: 30,
                                      child: CountryCodePicker(
                                        onChanged: (value) {
                                          country = value.name;
                                          print(value.code);
                                        },
                                        initialSelection: 'IN',
                                        showCountryOnly: true,
                                        alignLeft: true,
                                        showOnlyCountryWhenClosed: true,
                                      ),
                                      //   TextField(
                                      //   style: TextStyle(fontFamily: 'Livvic'),
                                      //   decoration: InputDecoration(
                                      //     border: OutlineInputBorder(
                                      //         borderSide: BorderSide(
                                      //             color: Colors.green, width: 2.0)),
                                      //   ),
                                      // ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 390,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Category',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                        width: 450,
                                        height: 30,
                                        child: DropdownButton<String>(
                                          value: selectedCategory,
                                          icon: const Icon(
                                              Icons.arrow_drop_down_sharp),
                                          iconSize: 24,
                                          hint: Text('Select Category'),
                                          underline: SizedBox(),
                                          elevation: 16,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Livvic',
                                              fontSize: 20),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              selectedCategory = newValue;
                                            });
                                            print(selectedCategory);
                                          },
                                          items: category
                                              .map<DropdownMenuItem<String>>(
                                                  (Category value) {
                                            return DropdownMenuItem<String>(
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
                                  top: 480,
                                  left: 600,
                                  child: Container(
                                    height: 30,
                                    width: 170,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Color(0xFF5A5A5A)),
                                    child: TextButton(
                                      onPressed: () async {
                                        if (_claimController.text != null &&
                                            _claimController.text.trim() !=
                                                '') {
                                          if (_truthController.text != null &&
                                              _truthController.text.trim() !=
                                                  '') {
                                            if (_urlController.text != null &&
                                                _urlController.text.trim() !=
                                                    '') {
                                              if (tags.length != 0) {
                                                if (language != null &&
                                                    language.trim() != '') {
                                                  if (country != null &&
                                                      country.trim() != '') {
                                                    if (selectedCategory !=
                                                            null &&
                                                        selectedCategory
                                                                .trim() !=
                                                            '') {
                                                      if (_image != null) {
                                                        _loadingDialog(
                                                            'Creating Feed....');
                                                        await fdb.FirebaseDB
                                                            .createFeed(
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

                                                        Navigator.pop(context);
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
                                                                fontSize: 18.0,
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
                                                        'Select a valid value in Geographical Location.',
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
                                                } else {
                                                  setState(() {
                                                    showToast(
                                                      'Select a valid value in Language.',
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
                                              } else {
                                                setState(() {
                                                  showToast(
                                                    'Fill in atleast 1 tag',
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
                                            } else {
                                              setState(() {
                                                showToast(
                                                  'Enter valid value in Url field.',
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
                                          } else {
                                            setState(() {
                                              showToast(
                                                'Enter valid value in Truth field.',
                                                position: ToastPosition.bottom,
                                                backgroundColor:
                                                    Color(0xFF5A5A5A),
                                                radius: 8.0,
                                                textStyle: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white),
                                              );
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            showToast(
                                              'Enter valid value in Claim field.',
                                              position: ToastPosition.bottom,
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
                                      child: Text(
                                        'Submit For Review',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                top: 330,
                                left: 650,
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color(0xFFA90015),
                                          width: 1.0)),
                                  child: TextButton(
                                    onPressed: () async {
                                      _loadingDialog('Uploading Image.....');
                                      uploadedImageUrl =
                                          await _uploadImage(_image, claimId);
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
                                  top: 150,
                                  left: 600,
                                  height: 120,
                                  width: 200,
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
                                          iconSize: 150,
                                          color: Colors.grey,
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(
                                              top: 50,
                                              bottom: 30,
                                              right: 20,
                                              left: 50),
                                          child: Text(
                                            'Image Selected!',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ))
                            ],
                          ),
                        ))
                    : Positioned(
                        top: 200,
                        left: 400,
                        child: Container(
                          height: 500,
                          width: 900,
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 50,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Summary',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 500,
                                      height: 30,
                                      child: TextField(
                                        controller: _claimController,
                                        style: TextStyle(fontFamily: 'Livvic'),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 10),
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
                                top: 100,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Youtube Url',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 500,
                                      height: 30,
                                      child: TextField(
                                        controller: _urlController,
                                        style: TextStyle(fontFamily: 'Livvic'),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 10),
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
                                top: 150,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Tags  ',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                        width: 350,
                                        height: 40,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 350,
                                              height: 30,
                                              child: TextField(
                                                controller: _tagsController,
                                                style: TextStyle(
                                                    fontFamily: 'Livvic'),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 10),
                                                  border: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Color(0xFFEF233C),
                                              width: 1.0)),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            tags.add(_tagsController.text);
                                            _tagsController.clear();
                                          });
                                        },
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                              color: Color(0xFFEF233C)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 180,
                                left: 140,
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children:
                                          List.generate(tags.length, (index) {
                                        return Container(
                                          height: 30,
                                          child: Card(
                                            elevation: 12,
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  tags[index],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                IconButton(
                                                    iconSize: 15,
                                                    icon: Icon(Icons.clear),
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        tags.removeAt(index);
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
                                top: 230,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Geo   ',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 475,
                                      height: 30,
                                      child: CountryCodePicker(
                                        onChanged: (value) {
                                          country = value.name;
                                          print(value.code);
                                        },
                                        initialSelection: 'IN',
                                        showCountryOnly: true,
                                        alignLeft: true,
                                        showOnlyCountryWhenClosed: true,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 280,
                                left: 40,
                                child: Row(
                                  children: [
                                    Text('Category',
                                        style: TextStyle(fontSize: 20)),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                        width: 450,
                                        height: 30,
                                        child: DropdownButton<String>(
                                          value: selectedCategory,
                                          icon: const Icon(
                                              Icons.arrow_drop_down_sharp),
                                          iconSize: 24,
                                          hint: Text('Select Category'),
                                          underline: SizedBox(),
                                          elevation: 16,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Livvic',
                                              fontSize: 20),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              selectedCategory = newValue;
                                            });
                                            print(selectedCategory);
                                          },
                                          items: category
                                              .map<DropdownMenuItem<String>>(
                                                  (Category value) {
                                            return DropdownMenuItem<String>(
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
                                  top: 400,
                                  left: 600,
                                  child: Container(
                                    height: 40,
                                    width: 170,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Color(0xFF5A5A5A)),
                                    child: TextButton(
                                      onPressed: () async {
                                        if (_claimController.text != null &&
                                            _claimController.text.trim() !=
                                                '') {
                                          if (_urlController.text != null &&
                                              _urlController.text.trim() !=
                                                  '') {
                                            if (tags.length != 0) {
                                              if (country != null &&
                                                  country.trim() != '') {
                                                if (selectedCategory != null &&
                                                    selectedCategory.trim() !=
                                                        '') {
                                                  if (_image != null) {
                                                    _loadingDialog(
                                                        'Creating Feed....');
                                                    await fdb.FirebaseDB
                                                        .createVideoFeed(
                                                            _claimController
                                                                .text,
                                                            _urlController.text,
                                                            tags,
                                                            country,
                                                            selectedCategory,
                                                            uploadedImageUrl,
                                                            claimId,
                                                            this
                                                                .widget
                                                                .feedType,
                                                            context);
                                                    Navigator.pop(context);
                                                    _submitDialog1(
                                                        'Feed Successfully Created');
                                                  } else {
                                                    setState(() {
                                                      showToast(
                                                        'No Image Selected. Select a valid image and upload it.',
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
                                                } else {
                                                  setState(() {
                                                    showToast(
                                                      'Select a valid value in Category.',
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
                                              } else {
                                                setState(() {
                                                  showToast(
                                                    'Select a valid value in Geographical Location.',
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
                                            } else {
                                              setState(() {
                                                showToast(
                                                  'Fill in atleast 1 tag',
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
                                          } else {
                                            setState(() {
                                              showToast(
                                                'Enter valid value in Url field.',
                                                position: ToastPosition.bottom,
                                                backgroundColor:
                                                    Color(0xFF5A5A5A),
                                                radius: 8.0,
                                                textStyle: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white),
                                              );
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            showToast(
                                              'Enter valid value in Summary field.',
                                              position: ToastPosition.bottom,
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
                                      child: Text(
                                        'Submit For Review',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  top: 270,
                                  left: 700,
                                  child: Container(
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Color(0xFFA90015),
                                            width: 1.0)),
                                    child: TextButton(
                                      onPressed: () async {
                                        _loadingDialog('Uploading Image.....');
                                        uploadedImageUrl =
                                            await _uploadImage(_image, claimId);
                                        Navigator.pop(context);
                                        _submitDialog('Image Uploaded');
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
                                  top: 120,
                                  left: 640,
                                  height: 120,
                                  width: 200,
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
                                          iconSize: 150,
                                          color: Colors.grey,
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(
                                              top: 50,
                                              bottom: 30,
                                              right: 20,
                                              left: 50),
                                          child: Text(
                                            'Image Selected!',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ))
                            ],
                          ),
                        )),
              ],
            )),
    );
  }
}
