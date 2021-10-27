import 'package:facto/model/user.dart' as u;
import 'package:facto/service/auth/auth.dart';
import 'package:facto/util/globals.dart';
import 'package:facto/util/images.dart';
import 'package:facto/widgets/secondary_top_bar.dart';
import 'package:facto/widgets/side_bar.dart';
import 'package:facto/widgets/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/database/firebase_db.dart' as fdb;
import 'package:oktoast/oktoast.dart';

class ManageUsers extends StatefulWidget {
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _cnfPasswordController = new TextEditingController();
  String role = 'Admin';
  UserCredential userN;
  bool isLoading = true;
  var users = List.filled(0, new u.User('', '', '', ''));

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
                    Icon(Icons.check_circle_outline,color: Colors.green,size: 40,),
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
            TextButton(onPressed: (){
              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return ManageUsers();}));

            }, child: Text('Dismiss',style: TextStyle(color: Colors.blueGrey),))
          ],
        ));
  }

  Future<void> _addUserDialog() {
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: Colors.white,
              content: Container(
                  height: Globals.getHeight(250),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                              hintText: 'Username',
                              suffixIcon: Icon(Icons.person),
                              border: UnderlineInputBorder()),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Globals.getWidth(20)),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              hintText: 'Name',
                              suffixIcon: Icon(Icons.person_outline_rounded),
                              border: UnderlineInputBorder()),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Globals.getWidth(20)),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.lock),
                              hintText: 'Password',
                              border: UnderlineInputBorder()),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Globals.getWidth(20)),
                        child: TextField(
                          controller: _cnfPasswordController,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.lock_open_outlined),
                              hintText: 'Confirm Password',
                              border: UnderlineInputBorder()),
                        ),
                      ),
                      Container(
                          width: Globals.getWidth(200),
                          child: DropdownButton<String>(
                            value: role,
                            icon: const Icon(Icons.arrow_drop_down_sharp),
                            iconSize: Globals.getWidth(24),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String newValue) {
                              setState(() {
                                role = newValue;
                              });
                              print(role);
                            },
                            items: <String>[
                              'Admin',
                              'Reviewer',
                              'Partner',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            }).toList(),
                          ))
                    ],
                  )),
              actions: [
                TextButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      if (_nameController.text != null &&
                          _nameController.text != '') {
                        if (_cnfPasswordController.text != null &&
                            _cnfPasswordController.text != '') {
                          if (_cnfPasswordController.text ==
                              _passwordController.text) {
                            _loadingDialog('Creating User');
                            try {
                              userN = await auth.createUserWithEmailAndPassword(
                                  email: _usernameController.text,
                                  password: _passwordController.text);
                              Navigator.pop(context);
                              _loadingDialog('User Created...Uploading Data');
                            } catch (e) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {
                                showToast(
                                  e.message,
                                  position: ToastPosition.bottom,
                                  backgroundColor: Color(0xFF5A5A5A),
                                  radius: 8.0,
                                  textStyle: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                );
                              });
                            }
                            try {
                              await fdb.FirebaseDB.createUser(
                                  userN.user.uid,
                                  userN.user.email,
                                  _nameController.text,
                                  role,
                                  context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              _submitDialog('User Succefully Created.');
                            } catch (e) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {
                                showToast(
                                  e.message,
                                  position: ToastPosition.bottom,
                                  backgroundColor: Color(0xFF5A5A5A),
                                  radius: 8.0,
                                  textStyle: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                );
                              });
                            }
                          } else {
                            setState(() {
                              showToast(
                                'Passwords Dont match',
                                position: ToastPosition.bottom,
                                backgroundColor: Color(0xFF5A5A5A),
                                radius: 8.0,
                                textStyle: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              );
                            });
                          }
                        } else {
                          Navigator.pop(context);
                          setState(() {
                            showToast(
                              'Invalid Data in Confirm Password',
                              position: ToastPosition.bottom,
                              backgroundColor: Color(0xFF5A5A5A),
                              radius: 8.0,
                              textStyle: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            );
                          });
                        }
                      } else {
                        setState(() {
                          showToast(
                            'Invalid Data in Name Field',
                            position: ToastPosition.bottom,
                            backgroundColor: Color(0xFF5A5A5A),
                            radius: 8.0,
                            textStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          );
                        });
                      }
                    }),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'))
              ],
            ));
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
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async{
    users = await fdb.FirebaseDB.getUsers(context).whenComplete((){
      setState(() {
        isLoading = false;
      });
    });
  }

  OverlayEntry floatingDropdown;
  bool isDropdownOpened = false;

  OverlayEntry floatingDropdown1;
  bool isDropdownOpened1 = false;

  OverlayEntry _createFloatingDropdown(BuildContext context,String status,String uid) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        // You can change the position here
        right: Globals.getWidth(400),
        width: Globals.getWidth(150),
        top: Globals.getHeight(400),
        height: Globals.getHeight(120),
        // Any child
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Removing User');
                    await fdb.FirebaseDB.deleteUser(uid, context).whenComplete(() {
                      Navigator.pop(context);
                      _submitDialog('User Deleted.');
                      floatingDropdown.remove();
                      setState(() {
                        isDropdownOpened = !isDropdownOpened;
                      });
                    });
                    // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return ManageUsers();}));
                  },
                  child: Text(
                    'Revoke',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Locking User');
                    await fdb.FirebaseDB.lockUser(uid, context).whenComplete(() {
                      Navigator.pop(context);
                      _submitDialog('User Locked/Unlocked.');
                      floatingDropdown.remove();
                      setState(() {
                        isDropdownOpened = !isDropdownOpened;
                      });
                    });
                    // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return ManageUsers();}));
                  },
                  child: Text(
                    status,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  OverlayEntry _createFloatingDropdown1(BuildContext context) {
    return OverlayEntry(builder: (context) {
      return Positioned(
        // You can change the position here
        right: Globals.getWidth(850),
        width: Globals.getWidth(150),
        top: Globals.getHeight(330),
        height: Globals.getHeight(210),
        // Any child
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Servers....');
                    var adUsers = await fdb.FirebaseDB.getFilteredUsers('Admin');
                    setState(() {
                      users = adUsers;
                    });
                      floatingDropdown1.remove();
                      setState(() {
                        isDropdownOpened1 = !isDropdownOpened1;
                    });
                      Navigator.pop(context);
                    // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return ManageUsers();}));
                  },
                  child: Text(
                    'Admin',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Servers....');
                    var adUsers = await fdb.FirebaseDB.getFilteredUsers('Reviewer');
                    setState(() {
                      users = adUsers;
                    });
                    floatingDropdown1.remove();
                    setState(() {
                      isDropdownOpened1 = !isDropdownOpened1;
                    });
                    Navigator.pop(context);
                    // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return ManageUsers();}));
                  },
                  child: Text(
                    'Reviewer',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Servers....');
                    var adUsers = await fdb.FirebaseDB.getFilteredUsers('Partner');
                    setState(() {
                      users = adUsers;
                    });
                    floatingDropdown1.remove();
                    setState(() {
                      isDropdownOpened1 = !isDropdownOpened1;
                    });
                    Navigator.pop(context);
                    // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return ManageUsers();}));
                  },
                  child: Text(
                    'Partner',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: Globals.getWidth(150),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    _loadingDialog('Getting Data from Servers....');
                    var adUsers = await fdb.FirebaseDB.getUsers(context);
                    setState(() {
                      users = adUsers;
                    });
                    floatingDropdown1.remove();
                    setState(() {
                      isDropdownOpened1 = !isDropdownOpened1;
                    });
                    Navigator.pop(context);
                    // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){return ManageUsers();}));
                  },
                  child: Text(
                    'All',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: Scaffold(
      body: isLoading?_loadingScreen('Getting Data from Servers.....'):Stack(
        children: [
          Positioned(
            child: TopBar(),
            top: 0.0,
          ),
          Positioned(
            child: SecondaryTopBar(new Text('Manage Users')),
            top: Globals.height * 2 / 33,
            right: 0.0,
          ),
          Positioned(left: 0.0, top: Globals.height * 2 / 33, child: SideBar()),
          Positioned(
            top: Globals.getHeight(150),
            left: Globals.getWidth(400),
            child: Text(
              'Hi, ${Globals.user.name}',
              style: TextStyle(
                  fontFamily: 'Livvic', color: Color(0xFFA90015), fontSize: 20),
            ),
          ),
          Positioned(
            top: Globals.getHeight(250),
            left: Globals.getWidth(750),
            child: Text(
              'Manage Admins',
              style: TextStyle(
                  fontFamily: 'Livvic', color: Colors.black, fontSize: 20),
            ),
          ),
          Positioned(
            top: Globals.getHeight(150),
            left: Globals.getWidth(1200),
            child: Container(
              height: Globals.getHeight(40),
              width: Globals.getWidth(150),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xFF5A5A5A)),
              child: TextButton(
                onPressed: () {
                  _addUserDialog();
                },
                child: Text(
                  'Create User',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
              top: Globals.getHeight(300),
              left: Globals.getWidth(400),
              child:
              Container(
                height: Globals.getHeight(400),
                width: Globals.getWidth(900),
                child: Card(
                  elevation: 12,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'User',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Text(
                                'Role Assigned',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              SizedBox(
                                width: Globals.getWidth(20),
                              ),
                              IconButton(icon: Icon(Icons.filter_alt),color: Colors.grey, onPressed: (){
                                setState(() {
                                  if (isDropdownOpened1) {
                                    floatingDropdown1.remove();
                                  } else {
                                    // findDropdownData();
                                    floatingDropdown1 =
                                        _createFloatingDropdown1(context);
                                    Overlay.of(context)
                                        .insert(floatingDropdown1);
                                  }

                                  isDropdownOpened1 =
                                  !isDropdownOpened1;
                                });

                              })
                            ],
                          )
                        ),
                        DataColumn(
                          label: Text(
                            'RSS',
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
                        DataColumn(
                          label: Text(
                            '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                      rows: List.generate(users.length, (index) {
                        return  DataRow(
                          cells: <DataCell>[
                            DataCell(Text(users[index].name)),
                            DataCell(Text(users[index].role)),
                            DataCell(Text(users[index].feeds.toString())),
                            DataCell(Text(users[index].factCheck.toString())),
                            DataCell(IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: (){
                                setState(() {
                                  if (isDropdownOpened) {
                                    floatingDropdown.remove();
                                  } else {
                                    // findDropdownData();
                                    floatingDropdown =
                                        _createFloatingDropdown(
                                            context,users[index].status,users[index].uid);
                                    Overlay.of(context)
                                        .insert(floatingDropdown);
                                  }
                                  isDropdownOpened =
                                  !isDropdownOpened;
                                });
                              },
                            )),
                          ],
                        );
                      })
                    ),
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}
