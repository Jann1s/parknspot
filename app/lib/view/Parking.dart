import 'package:flutter/material.dart';

class Parking extends StatefulWidget {
  State<StatefulWidget> createState() {
    return ParkingState();
  }
}

class ParkingState extends State<Parking> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(35),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  child: Text(
                    'Set location',
                    style: TextStyle(fontSize: 35.0)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(10),
                  onPressed: (){}
                ),
              )
            ],
          ),
          Divider(
            color: Colors.green,
            thickness: 5,
            indent: 20,
            endIndent: 20,
            height: 35,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Set availability:', style: TextStyle(fontSize: 20),)
                  ],
                ),
                Row(children: <Widget>[],),
                FlatButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  child: Text('Full', style: TextStyle(fontSize: 15),), 
                  onPressed: () {},
                ),
                FlatButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  child: Text('1 - 4 available spots', style: TextStyle(fontSize: 15)), 
                  onPressed: () {},
                ),
                FlatButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  child: Text('5 - 10 available spots', style: TextStyle(fontSize: 15)), 
                  onPressed: () {},
                ),
                FlatButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  child: Text('11 - 20 available spots', style: TextStyle(fontSize: 15)), 
                  onPressed: () {},
                ),
                FlatButton(
                  color: Colors.grey,
                  textColor: Colors.white,
                  child: Text('21+ available spots', style: TextStyle(fontSize: 15)), 
                  onPressed: () {},
                ),
                FlatButton(
                  child: Text(
                    'Confirm',
                    style: TextStyle(fontSize: 20.0)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(10),
                  onPressed: (){}
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
