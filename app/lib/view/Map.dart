import 'dart:async';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

import 'package:parknspot/controller/MapController.dart';
import 'package:parknspot/ThemeGlobals.dart';
import 'package:parknspot/credentials.dart';
import 'package:parknspot/main.dart';
import 'package:parknspot/Models/Places.dart';

class MyMap extends StatefulWidget {
  State<StatefulWidget> createState() {
    return MyMapState();
  }
}

class MyMapState extends State<MyMap> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  //final Map<String, Marker> _markers = {};
  Set<Marker> _markers = {};
  List<Placemark> placemarks;
  Position position;
  String searchAddress;
  MapController _mapController;
  List<Places> _suggestedList = [];

  Completer<GoogleMapController> _googleMapsController = Completer();

  static CameraPosition _startPosition;

  MyMapState() {
    _mapController = new MapController(this);
    _checkSpots(5000);
    //_getStartLocation();
  }

  @override
  void initState()
  {
    _getStartLocation();
  }

  void _getStartLocation() async
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _startPosition = CameraPosition(
        target: LatLng(
          position.latitude,
          position.longitude
        ),
        zoom: 14,
      );
    });
  }

  void _checkSpots(int radius, [double lat, double lon]) async {
    Set<Marker> tmpMarkers =
        await _mapController.getParkingLocations(radius, lat, lon);

    setState(() {
      _markers.addAll(tmpMarkers);
    });
  }

  Completer<GoogleMapController> _controller = Completer();

//Get places suggestions from Places API
  Future<Void> _getLocationResults(String input) async {
    List<Places> _displayResults = [];
    if ((input.isEmpty)) {
      Main.showToast('Enter search text');
    } else {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String type = '(regions)';
      String request = '$baseURL?input=$input&key=$PLACES_API_KEY&type=$type';
      Response response = await Dio().get(request);
      final _predictions = response.data['predictions'];

      for (var i = 0; i < _predictions.length; i++) {
        String name = _predictions[i]['description'];
        _displayResults.add(Places(name));
        print(name);
      }
      setState(() {
        _suggestedList = _displayResults;
      });
    }
  }

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

  //Zoom to current location
  Future<void> _moveToPosition(position) async {
    final GoogleMapController mapController = await _controller.future;
    if (mapController == null) return;
    print('moving to position ${position.latitude}, ${position.longitude}');
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15.0,
    )));
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
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    if(_startPosition == null)
    {
      return Container(child: Center(child: 
        Loading(
          indicator: BallPulseIndicator(),
          size: 100,
          color: Theme.of(context).primaryColor,
        )
      ));
    }else{
    super.build(context);
      return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _startPosition,
              markers: _markers,
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
                            icon: Icon(Icons.search), onPressed: () {})),
                    onChanged: (text) {
                      _getLocationResults(text);
                    },
                  ),
                )),
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 65.0, 15.0, 0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestedList.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return placesCardBuilder(context, index);
                  }),
            ),
            Container(
              margin: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: _getLocation,
                  tooltip: 'Get Location',
                  child: Icon(Icons.my_location),
                ),
              ),
            ),
            Container(
              margin: EdgeInsetsDirectional.fromSTEB(0, 120, 10, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () {
                    _checkSpots(3000);
                  },
                  child: Icon(Icons.local_parking),
                ),
              ),
            ),
          ],
        ),
      );  
    }
  }

//Suggestions card builder
  Widget placesCardBuilder(BuildContext context, int index) {
    return Card(
      elevation: 1.0,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text(_suggestedList[index].placeName),
            )
          ],
        ),
        onTap: () async {
          final GoogleMapController placesController = await _controller.future;
          Geolocator()
              .placemarkFromAddress(_suggestedList[index].placeName)
              .then((result) {
            placesController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(
                  result[0].position.latitude, result[0].position.longitude),
              zoom: 10.0,
            )));
            setState(() {
              _suggestedList = [];
            });
            _checkSpots(5000, result[0].position.latitude,
                result[0].position.longitude);
          });
        },
      ),
      margin: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
    );
  }
}
