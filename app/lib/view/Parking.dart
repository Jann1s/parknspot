import 'package:flutter/material.dart';

class Parking extends StatefulWidget {
  State<StatefulWidget> createState() {
    return ParkingState();
  }
}

class ParkingState extends State<Parking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'SAD Parking',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
