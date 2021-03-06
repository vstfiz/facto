import 'package:auto_size_text/auto_size_text.dart';
import 'package:facto/model/category.dart';
import 'package:facto/model/claims.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/view/review/review.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;
import 'package:language_pickers/language_picker_dropdown.dart';
import 'package:language_pickers/languages.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewFeed extends StatefulWidget {
  final String claimId;

  ReviewFeed(this.claimId);

  @override
  _ReviewFeedState createState() => _ReviewFeedState();
}

class _ReviewFeedState extends State<ReviewFeed> {
  bool isLoading = true;
  TextEditingController _claimController = new TextEditingController();
  TextEditingController _truthController = new TextEditingController();
  TextEditingController _urlController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  TextEditingController _commentController = new TextEditingController();
  List<String> geo = [];
  String language;
  String selectedCategory;
  var category = List.filled(0, Category('', ''), growable: true);
  String country;
  Claims claim;
  String status;
  String tags;

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
  void initState() {
    super.initState();
    _getData();
  }

  void _launchURL() async => await canLaunch(claim.url2)
      ? await launch(claim.url2)
      : throw 'Could not launch ${claim.url2}';

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

  _getData() async {
    claim = await fdb.FirebaseDB.getPartnerRequestFromId(this.widget.claimId)
        .whenComplete(() async {
      category = await fdb.FirebaseDB.getCategory(context).whenComplete(() async {
        geo = await fdb.FirebaseDB.getGeo(context).whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      });
    });
    print(claim == null);
    status = claim.status;
    print(status);
    tags = '';
    await claim.tags.forEach((element) {
      tags = tags + element + ", ";
    });
    _commentController.text = claim.comment;
    _urlController.text = claim.url1;
    _claimController.text = claim.news;
    _truthController.text = claim.truth;
    _timeController.text = claim.date;
    selectedCategory = claim.category;
    country = claim.geo;
    selectedCategory = claim.category;

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
      backgroundColor: Color(0xFFE5E5E5),
      body: isLoading
          ? _loadingScreen('Getting Data from Servers.....')
          : Stack(
              children: [
                Positioned(
                  child: TopBar(),
                  top: 0.0,
                ),
                Positioned(
                  child: SecondaryTopBar(new Text('Manage Feeds')),
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
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(builder: (context) {
                          return Review(true);
                        }));
                      },
                    )),
                Positioned(
                    left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
                Positioned(
                    top: Globals.getHeight(150),
                    left: Globals.getWidth(400),
                    child: Container(
                      height: Globals.getHeight(600),
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
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(50),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(500),
                                  height: Globals.getHeight(30),
                                  child: TextField(
                                    controller: _claimController,
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: Globals.getHeight(100),
                            left: Globals.getWidth(40),
                            child: Row(
                              children: [
                                Text('Truth ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(50),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(500),
                                  height: Globals.getHeight(30),
                                  child: TextField(
                                    controller: _truthController,
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
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
                                Text('Url    ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(50),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(400),
                                  height: Globals.getHeight(30),
                                  child: TextField(
                                    controller: _urlController,
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: Globals.getHeight(200),
                            left: Globals.getWidth(40),
                            child: Row(
                              children: [
                                Text('Date  ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(50),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(400),
                                  child: TextField(
                                    controller: _timeController,
                                    decoration: InputDecoration(
                                      hintText: '(DD/MM/YYYY)'
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
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
                                Text('Tags',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(50),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(400),
                                  child: AutoSizeText(
                                    tags,
                                    style: TextStyle(
                                        fontFamily: 'Livvic', fontSize: 20),
                                    softWrap: true,
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
                                Text('Language',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(40),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(400),
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
                                    initialValue: claim.language == 'English' ? 'en':'hi',
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: Globals.getHeight(350),
                            left: Globals.getWidth(40),
                            child: Row(
                              children: [
                                Text('Geo',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(50),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(400),
                                  child:DropdownButton<String>(
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
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: Globals.getHeight(400),
                            left: Globals.getWidth(40),
                            child: Row(
                              children: [
                                Text('Category',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(40),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(400),
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
                                Text('If Rejected then why',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: Globals.getWidth(40),
                                ),
                                SizedBox(
                                  width: Globals.getWidth(400),
                                  child: TextField(
                                    controller: _commentController,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        contentPadding:
                                            EdgeInsets.only(bottom: 10)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              top: Globals.getHeight(530),
                              left: Globals.getWidth(600),
                              child: Row(
                                children: [
                                  Container(
                                    height: Globals.getHeight(40),
                                    width: Globals.getWidth(100),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Color(0xFF5A5A5A)),
                                    child: TextButton(
                                      onPressed: () async {
                                        _loadingDialog('Uploading Data...');
                                        status = 'True';
                                        await fdb.FirebaseDB
                                            .updatePartnerRequest(
                                                _commentController.text,
                                                status,
                                                this.widget.claimId);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Approve',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Globals.getWidth(50),
                                  ),
                                  Container(
                                    height: Globals.getHeight(40),
                                    width: Globals.getWidth(100),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Color(0xFF5A5A5A)),
                                    child: TextButton(
                                      onPressed: () async {
                                        setState(() {
                                          status = 'Rejected';
                                        });
                                        _loadingDialog('Uploading Data...');
                                        await fdb.FirebaseDB
                                            .updatePartnerRequest(
                                                _commentController.text,
                                                status,
                                                this.widget.claimId);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Positioned(
                              top: Globals.getHeight(210),
                              left: Globals.getWidth(480),
                              child: Container(
                                height: Globals.getHeight(200),
                                width: Globals.getWidth(400),
                                child: TextButton(
                                  onPressed: _launchURL,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(claim.url2))),
                              )),
                        ],
                      ),
                    )),
              ],
            ),
    );
  }
}
