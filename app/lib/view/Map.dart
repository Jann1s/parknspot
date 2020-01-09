import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  final Map<String, Marker> _markers = {};
  List<Placemark> placemarks;
  Position position;
  String searchAddress;

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _emmenPosition = CameraPosition(
    target: LatLng(52.78586767371929, 6.8975849999999355),
    zoom: 14,
  );

//Get address from location
  Future<String> _getAddress(position) async {
    placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark position = placemarks[0];
      return position.thoroughfare + ', ' + position.locality;
    }
    return "";
  }

  //Pan/Zoom to current location
  Future<void> _moveToPosition(position) async {
    final GoogleMapController mapController = await _controller.future;
    if (mapController == null) return;
    print('moving to position ${position.latitude}, ${position.longitude}');
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15.0,
    )));
  }
//Search and zoom to address

  void _search() {
    GoogleMapController mapController;
    Geolocator().placemarkFromAddress(searchAddress).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15.0,
      )));
    });
  }

//Get current Location
  Future<void> _getLocation() async {
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
        infoWindow: InfoWindow(
            title:
                '${placemarks[0].thoroughfare}, ${placemarks[0].postalCode}'),
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
          Positioned(
              top: 15.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: ThemeGlobals.inputFieldRadius,
                    color: ThemeGlobals.secondaryTextColor),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _search,
                      )),
                  onChanged: (val) {
                    setState(() {
                      searchAddress = val;
                    });
                  },
                ),
              )),
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
