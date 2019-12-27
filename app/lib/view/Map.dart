import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  State<StatefulWidget> createState() {
    return MyMapState();
  }
}

class MyMapState extends State<MyMap> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final Map<String, Marker> _markers = {};

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _emmenPosition = CameraPosition(
    target: LatLng(52.78586767371929, 6.8975849999999355),
    zoom: 14,
  );

//Get address from location
  Future<String> _getAddress(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }

  //Pan/Zoom to current location
  Future<void> _moveToPosition(Position pos) async {
    final GoogleMapController mapController = await _controller.future;
    if (mapController == null) return;
    print('moving to position ${pos.latitude}, ${pos.longitude}');
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 15.0,
    )));
  }

//Get current Location
  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(
        'got current location as ${currentLocation.latitude}, ${currentLocation.longitude}');
    await _getAddress(currentLocation);
    await _moveToPosition(currentLocation);
    final bitmapIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);

    setState(() {
      _markers.clear();

      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: "YOU"),
        icon: bitmapIcon,
      );
      _markers["Current Location"] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _emmenPosition,
            markers: _markers.values.toSet(),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller.complete(controller);
              });
            },
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
            height: 40,
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search location',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.location_searching),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
