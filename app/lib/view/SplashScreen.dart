import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parknspot/main.dart';

class SplashScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<MyApp> {
  
  int splashScreenDuration = 4; // time in seconds
  var bgcolor = Colors.blue[300];
  String splashImage = 'assets/splashAnimation.gif';
  double splashImageSize = 200;

  @override
  void initState(){
    super.initState();
    Future.delayed(
      Duration(seconds: splashScreenDuration),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar()
      ),
      body: Center(
        child: Image.asset(
          splashImage,
          height: splashImageSize,
          width: splashImageSize,
        ),
      ),
    );
  }
}