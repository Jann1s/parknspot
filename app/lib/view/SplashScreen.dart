import 'package:flutter/material.dart';
import 'Login.dart';

class SplashScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  
  int splashScreenDuration = 4; // time in seconds
  var bgcolor = Colors.blue[300];
  String splashImage = 'assets/splash_icon.png';
  double splashImageSize = 268;

  @override
  void initState(){
    super.initState();

    //Change here the condition when it has to redirect to another screen, atm its just a countdown
    Future.delayed(
      Duration(seconds: splashScreenDuration),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          )
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
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