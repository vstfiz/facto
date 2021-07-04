import 'package:facto/model/user.dart';
import 'package:facto/service/auth/auth.dart';
import 'package:facto/util/images.dart';
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                    height: 170,
                  ),
                  Image.network(
                    Images.logo,
                    height: 100,
                    width: 300,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Card(
                      elevation: 10,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 20,
                              child: Container(
                                width: 300,
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
                              top: 70,
                              child: Container(
                                width: 300,
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
                              top: 120,
                              left: 40,
                              child: TextButton(
                                onPressed: (){
                                  Navigator.of(context)
                                      .pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (context) {
                                            return ForgotPassword();
                                          }));
                                },
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              )),
                          Positioned(
                            top: 180,
                            left: 60,
                            child: Container(
                              height: 50,
                              width: 170,
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
                                        await fdb.FirebaseDB.getUserDetails(
                                                userD.uid, context)
                                            .whenComplete((){
                                              Navigator.pop(context);
                                          Navigator.of(context)
                                              .pushReplacement(
                                              new MaterialPageRoute(
                                                  builder: (context) {
                                                    return HomeScreen(true);
                                                  }));
                                        }
                                                );
                                      } catch (e) {
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
