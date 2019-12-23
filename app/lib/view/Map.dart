import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parknspot/ThemeGlobals.dart';

class MyMap extends StatefulWidget {
  State<StatefulWidget> createState() {
    return MyMapState();
  }
}

class MyMapState extends State<MyMap> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _emmenPosition = CameraPosition(
    target: LatLng(52.78586767371929, 6.8975849999999355),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _emmenPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Container(
          margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
          height: 40,
          color: ThemeGlobals.secondaryTextColor,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: ThemeGlobals.inputFieldRadius,
              ),
              labelText: 'Search location',
            ),
          ),
        ),
      ],
    )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
