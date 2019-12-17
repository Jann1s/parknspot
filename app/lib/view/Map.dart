import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMap extends StatefulWidget {
  State<StatefulWidget> createState() {
    return MyMapState();
  }
}

class MyMapState extends State<MyMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'SAD Map',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
