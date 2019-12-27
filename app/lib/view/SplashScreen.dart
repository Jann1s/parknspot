import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  var bgColor = Colors.blue[300];
  String splashImage = 'assets/loginAnimation.gif';
  double splashImageSize = 268;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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