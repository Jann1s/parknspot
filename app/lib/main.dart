import 'package:flutter/material.dart';
import 'package:parknspot/view/Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Login(),
      theme: ThemeData(
        brightness: Brightness.light,
        // Define the default font family.
        fontFamily: 'Montserrat',
        primarySwatch: Colors.blue,
      ),
    );
  }
}
