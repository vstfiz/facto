import 'package:facto/util/images.dart';
import 'package:facto/view/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Center(
                child: Column(
              children: [
                SizedBox(
                  height: 170,
                ),
                Image.asset(
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
                              onPressed: () {
                                if (_usernameController.text != null &&
                                    _usernameController.text != '') {
                                  if (_passwordController.text != null &&
                                      _passwordController.text != '') {
                                    Navigator.of(context).pushReplacement(
                                        new MaterialPageRoute(
                                            builder: (context) {
                                      return HomeScreen();
                                    }));
                                  }
                                } else {}
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
        onWillPop: null);
  }
}
