import 'package:facto/util/images.dart';
import 'package:facto/view/auth/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';


class ForgotPassword extends StatefulWidget {
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _usernameController = new TextEditingController();
  double opacity = 0.0;

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
                                  left: 40,
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.of(context)
                                            .pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) {
                                                  return LogIn();
                                                }));
                                    },
                                    child: Text(
                                      'Back To login',
                                      style: TextStyle(color: Colors.blueAccent),
                                    ),
                                  )),
                              Positioned(
                                  top: 110,
                                  left: 40,
                                  child:  Opacity(
                                    opacity: opacity,
                                    child: Container(
                                      height: 40,
                                      width: 220,
                                      child: Text(
                                        'Password Recovery link sent.',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  ),
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
                                          try {
                                            await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: _usernameController.text);
                                            setState(() {
                                              opacity = 1.0;
                                            });
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
                                      'Send Reset Link',
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
