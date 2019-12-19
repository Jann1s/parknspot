import 'package:flutter/material.dart';

class Parking extends StatefulWidget {
  State<StatefulWidget> createState() {
    return ParkingState();
  }
}

class ParkingState extends State<Parking> {
  EAvailability _availability = EAvailability.Full;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(30),
      child: Center(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Center(
                    child: Text('Set your location',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade800
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eleifend ut dolor ut faucibus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc nec mollis tellus, vel dapibus sapien."),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text('Set location',
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat')),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Divider(
                color: Colors.blue.shade300,
                thickness: 2,
                indent: 5,
                endIndent: 5,
                height: 10,
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Center(
                      child: Text('Set availability',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade800
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        buildAvailabilityButton("Full", EAvailability.Full),
                        buildAvailabilityButton("1 - 4 available spots", EAvailability.Low),
                        buildAvailabilityButton("5 - 10 available spots", EAvailability.Medium),
                        buildAvailabilityButton("11 - 20 available spots", EAvailability.High),
                        buildAvailabilityButton("21+ available spots", EAvailability.Empty),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.blue.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text('Set availability',
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat')),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      )
    );
  }

  Widget buildAvailabilityButton(String text, EAvailability type) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: (_availability == type) ? Colors.blue.shade300 : Colors.grey,
        textColor: Colors.white,
        child: Text(text, style: TextStyle(fontSize: 15),),
        onPressed: () {
          setState(() {
            _availability = type;
          });
        },
      ),
    );
  }
}

enum EAvailability {
  Full,
  Low,
  Medium,
  High,
  Empty
}
