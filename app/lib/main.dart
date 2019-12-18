import 'package:flutter/material.dart';
import 'package:parknspot/view/Login.dart';
import 'package:parknspot/view/SplashScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Login(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
          child: AppBar()
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        // Define the default font family.
        fontFamily: 'Montserrat',
        primarySwatch: Colors.blue,
      ),
    );
  }
}
