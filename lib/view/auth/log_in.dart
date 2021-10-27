import 'package:facto/model/user.dart';
import 'package:facto/service/auth/auth.dart';
import 'package:facto/util/images.dart';
import 'package:facto/view/create_feed/create_feed.dart';
import 'package:facto/view/forgot_password/forgot_password.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/util/globals.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:facto/database/firebase_db.dart' as fdb;

class LogIn extends StatefulWidget {
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  static Future<void> _lockDialog(String value, BuildContext context) {
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
                        SizedBox(
                          width: Globals.getWidth(20),
                        ),
                        Text(
                          value,
                          style: TextStyle(
                              fontFamily: "Livvic",
                              fontSize: 18,
                              color: Colors.red,
                              letterSpacing: 1),
                        )
                      ],
                    ),
                  )),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder: (context) {
                      return LogIn();
                    }));
                  },
                  child: Text('Dismiss'),
                ),
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



  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: OKToast(
            child: Scaffold(
              body: Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: Globals.getHeight(170),
                  ),
                  Image.network(
                    Images.logo,
                    height: Globals.getHeight(100),
                    width: Globals.getWidth(300),
                  ),
                  SizedBox(
                    height: Globals.getHeight(50),
                  ),
                  SizedBox(
                    height: Globals.getHeight(300),
                    width: Globals.getWidth(300),
                    child: Card(
                      elevation: 10,
                      child: Stack(
                        children: [
                          Positioned(
                              top: Globals.getHeight(20),
                              child: Container(
                                width: Globals.getWidth(300),
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: 'Username',
                                      suffixIcon: Icon(Icons.person)),
                                ),
                              )),
                          Positioned(
                              top: Globals.getHeight(70),
                              child: Container(
                                width: Globals.getWidth(300),
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: 'Password',
                                      suffixIcon: Icon(Icons.lock)),
                                ),
                              )),
                          Positioned(
                              top: Globals.getHeight(120),
                              left: Globals.getWidth(40),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      new MaterialPageRoute(builder: (context) {
                                    return ForgotPassword();
                                  }));
                                },
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              )),
                          Positioned(
                            top: Globals.getHeight(180),
                            left: Globals.getWidth(60),
                            child: Container(
                              height: Globals.getHeight(50),
                              width: Globals.getWidth(170),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Color(0xFF5A5A5A)),
                              child: TextButton(
                                onPressed: () async {
                                  if (_usernameController.text != null &&
                                      _usernameController.text != '') {
                                    if (_passwordController.text != null &&
                                        _passwordController.text != '') {
                                      try {
                                        _loadingDialog("Authenticating");
                                        auth.User userD = await signInWithEmail(
                                            _usernameController.text,
                                            _passwordController.text);
                                        bool status =
                                            await fdb.FirebaseDB.getUserDetails(
                                                userD.uid, context);
                                        print(status.toString() +
                                            "vrvfs     " +
                                            Globals.isDeleted.toString());
                                        if (Globals.isDeleted) {
                                          _lockDialog(
                                              'Sorry, your user account seems to have been deleted for violations. Please contact the panel admin for new account creation',
                                              context);
                                        } else {
                                          if (status) {
                                            await signOutWithGoogle();
                                            _lockDialog(
                                                'Sorry, your user account seems to have been locked for violations. Please contact the panel admin for resolution',
                                                context);
                                          } else {
                                            Navigator.pop(context);
                                            if (Globals.userLevel ==
                                                'Partner') {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      new MaterialPageRoute(
                                                          builder: (context) {
                                                return CreateFeed(true);
                                              }));
                                            } else {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      new MaterialPageRoute(
                                                          builder: (context) {
                                                return HomeScreen(true);
                                              }));
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        Navigator.pop(context);
                                        print(
                                            'Failed with error code: ${e.code}');
                                        setState(() {
                                          showToast(
                                            e.message,
                                            position: ToastPosition.bottom,
                                            backgroundColor: Color(0xFF5A5A5A),
                                            radius: 8.0,
                                            textStyle: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          );
                                        });
                                        print(e.message);
                                      }
                                    } else {
                                      setState(() {
                                        showToast(
                                          "Invalid Password. Please enter a valid Password",
                                          position: ToastPosition.bottom,
                                          backgroundColor: Color(0xFF5A5A5A),
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
                                        "Invalid Username. Please enter a valid Username",
                                        position: ToastPosition.bottom,
                                        backgroundColor: Color(0xFF5A5A5A),
                                        radius: 13.0,
                                        textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      );
                                    });
                                    print('else');
                                  }
                                },
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
            ),
          ),
        ),
        onWillPop: null);
  }
}
