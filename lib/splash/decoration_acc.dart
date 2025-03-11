import 'dart:async';

import 'package:flutter/material.dart';

class DecoAnim extends StatefulWidget {
  @override
  _DecoAnimState createState() => _DecoAnimState();
}

class _DecoAnimState extends State<DecoAnim> {
  double t_niveau = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inittimer();
  }

  Curve anim = Curves.linearToEaseOut;
  Duration dur = Duration(milliseconds: 1800);
  void inittimer() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (t_niveau < MediaQuery.of(context).size.height / 3) {
          t_niveau = MediaQuery.of(context).size.height / 3;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          AnimatedPositioned(
              top: t_niveau + 30,
              left: -10,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff00C600).withOpacity(0.2),
                          Color(0xff00C600)
                        ])),
              ),
              duration: dur,
              curve: anim),
          AnimatedPositioned(
              top: t_niveau + 120,
              right: 50,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff00C600).withOpacity(0.2),
                          Color(0xff00C600)
                        ])),
              ),
              duration: dur,
              curve: anim),
          AnimatedPositioned(
              top: t_niveau + 100,
              left: 15,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.withOpacity(0.3),
                          Colors.orange
                        ])),
              ),
              duration: dur,
              curve: anim),
          AnimatedPositioned(
              top: t_niveau,
              right: 75,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.orange.withOpacity(0.3),
                          Colors.orange
                        ])),
              ),
              duration: dur,
              curve: anim),
          AnimatedPositioned(
              top: t_niveau + 60,
              left: 0,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pink[100]!.withOpacity(0.1),
                          Colors.red[600]!
                        ])),
              ),
              duration: dur,
              curve: anim),
          AnimatedPositioned(
              top: t_niveau + 150,
              left: 0,
              right: 100,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pink[100]!.withOpacity(0.1),
                          Colors.red[600]!
                        ])),
              ),
              duration: dur,
              curve: anim),
          AnimatedPositioned(
              top: t_niveau,
              right: -30,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.lightBlue[600]!,
                            Colors.lightBlue[100]!
                          ]))),
              duration: dur,
              curve: anim),
          AnimatedPositioned(
              top: t_niveau + 100,
              left: 0,
              right: 100,
              child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.lightBlue[600]!,
                            Colors.lightBlue[100]!
                          ]))),
              duration: dur,
              curve: anim),
          AnimatedPositioned(
              top: t_niveau - 50,
              left: 0,
              right: 120,
              child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blueAccent, Colors.teal]))),
              duration: dur,
              curve: anim),
        ],
      ),
    );
  }
}
