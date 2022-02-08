import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:facto/util/globals.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget build(BuildContext context) {
    double h = Globals.height;
    double w = Globals.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121217),
        body: Stack(
          children: [
            Container(
              height: h,
              width: w,
            ),
            Positioned(
              child: _appBar(h, w),
              left: 0.0,
              top: 0.0,
            ),
          ],
        ),
      ),
      top: true,
    );
  }

  Widget _appBar(double h, double w) {
    return Container(
      height: h * 0.08,
      width: w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              left: 0.0,
              top: h * 0.01,
              bottom: h * 0.01,
              child: Container(
                height: h * 0.06,
                child: TextButton(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              )),
          Container(
            width: w *0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: h *0.01,
                ),
                Container(
                  width: w * 0.5,
                  height: h * 0.04,
                  child: Center(
                    child: AutoSizeText(
                      'Vivek\'s Locker Room'.toUpperCase(),
                      style: TextStyle(color: Colors.white, letterSpacing: 1.8, fontSize: 18),
                    ),
                  )
                ),
                Container(
                  width: w * 0.5,
                  height: h * 0.02,
                  child: Center(
                    child: AutoSizeText(
                      '4 Chat Members',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                SizedBox(
                  height: h *0.01,
                ),

              ],
            ),
          ),
          Positioned(
              right: 0.0,
              top: h * 0.01,
              bottom: h * 0.01,
              child: Row(

                children: [
                  Container(
                    height: h * 0.06,
                    child: TextButton(
                      child: Icon(
                        Icons.open_with,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: h * 0.06,
                    child: TextButton(
                      child: Icon(
                        Icons.video_call_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _chatScreen() {}

  Widget _sendBar() {}
}
