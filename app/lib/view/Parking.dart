import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parknspot/ThemeGlobals.dart';
import 'package:parknspot/controller/ParkingController.dart';
import 'package:parknspot/APIBackend.dart';

class Parking extends StatefulWidget {
  State<StatefulWidget> createState() {
    return ParkingState();
  }
}

class ParkingState extends State<Parking> {
  ParkingController _parkingController;
  EAvailability _availability;
  bool _isLocationSet = false;

  ParkingState() {
    _parkingController = ParkingController(this);
    _checkLocationSet();
  }

  void _checkLocationSet() async {
    bool tmpLocSet = await APIBackend().isUserLocationSet();
    setState(() {
      _isLocationSet = tmpLocSet;
    });
  }

  Widget _buildLocationWidget() {
    if (!_isLocationSet) {
      return RaisedButton(
        color: ThemeGlobals.primaryButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: ThemeGlobals.buttonBorderRadius,
        ),
        child: Text('Set location',
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: ThemeGlobals.mediumWeight,
                fontFamily: 'Montserrat')),
        onPressed: () async {
          _parkingController.setLocation();
          setState(() {
            _isLocationSet = true;
          });
        },
      );
    } else {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            color: ThemeGlobals.primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: ThemeGlobals.buttonBorderRadius,
            ),
            child: Text('Unset location',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: ThemeGlobals.mediumWeight,
                    fontFamily: 'Montserrat')),
            onPressed: () async {
              _parkingController.unsetLocation();
              setState(() {
                _isLocationSet = false;
              });
            },
          ),
          RaisedButton(
            color: ThemeGlobals.primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: ThemeGlobals.buttonBorderRadius,
            ),
            child: Text('Find my car',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: ThemeGlobals.mediumWeight,
                    fontFamily: 'Montserrat')),
            onPressed: () async {
              if (_isLocationSet) {}
            },
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Center(
                    child: Text(
                      'Set your location',
                      style: TextStyle(
                          fontSize: 20,
                          color: ThemeGlobals.tertiaryTextColor,
                          fontWeight: ThemeGlobals.heading,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                      "Set your location and forget about where you parked! Later, you can find your vehicle in the map.",
                      style: TextStyle(
                          fontSize: 18,
                          color: ThemeGlobals.tertiaryTextColor,
                          fontWeight: ThemeGlobals.description,
                          fontFamily: 'Montserrat')),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                ),
                _buildLocationWidget()
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Divider(
                color: ThemeGlobals.primaryButtonColor,
                thickness: 2,
                indent: 5,
                endIndent: 5,
                height: 10,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Center(
                        child: Text(
                          'Set availability',
                          style: TextStyle(
                              fontSize: 20,
                              color: ThemeGlobals.tertiaryTextColor,
                              fontWeight: ThemeGlobals.subHeading,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          buildAvailabilityButton(
                              "1 - 4 available spots", EAvailability.Low),
                          buildAvailabilityButton(
                              "5 - 10 available spots", EAvailability.Medium),
                          buildAvailabilityButton(
                              "11 - 20 available spots", EAvailability.High),
                          buildAvailabilityButton(
                              "21+ available spots", EAvailability.Empty),
                          buildAvailabilityButton("Full", EAvailability.Full),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: RaisedButton(
                        color: ThemeGlobals.primaryButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: ThemeGlobals.buttonBorderRadius,
                        ),
                        child: Text('Set availability',
                            style: TextStyle(
                                fontSize: 25.0,
                                color: ThemeGlobals.secondaryTextColor,
                                fontWeight: ThemeGlobals.mediumWeight,
                                fontFamily: 'Montserrat')),
                        onPressed: () async {
                          if (_availability != null) {
                            bool operationStatus = await _parkingController
                                .setAvailability(_availability.index);
                            if (operationStatus) {
                              // Display success message
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      content: Container(
                                        height: 75,
                                        width: 150,
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              Text('Success!'),
                                              RaisedButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              // Display error message
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      content: Container(
                                        height: 75,
                                        width: 150,
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                  'Ops! Something went wrong...'),
                                              RaisedButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          } else {
                            // Display message stating to select availability
                            print('_availability not set');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    content: Container(
                                      height: 75,
                                      width: 150,
                                      child: Center(
                                        child: Column(
                                          children: <Widget>[
                                            Text('Please set an availability'),
                                            RaisedButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildAvailabilityButton(String text, EAvailability type) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: (_availability == type)
            ? ThemeGlobals.primaryButtonColor
            : ThemeGlobals.secondaryButtonColor,
        textColor: Colors.white,
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
        onPressed: () {
          setState(() {
            _availability = type;
          });
        },
      ),
    );
  }
}

enum EAvailability { Full, Low, Medium, High, Empty }
