import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parknspot/view/Map.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {
  MyMapState _myMapState;

  MapController(MyMapState myMapState){
    _myMapState = myMapState;
  }

  Future<Set<Marker>> getParkingLocations(int radius, [double lat, double lon]) async{
    double _lat;
    double _lon;

    if(lat == null && lon == null)
    {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _lat = position.latitude;
      _lon = position.longitude;
    }else{
      _lat = lat;
      _lon = lon;
    }
    
    
    Set<Marker> _results = Set();
    
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getParkingLocations'
    );
    try {
      HttpsCallableResult resp = await callable.call(<String,dynamic>{
        'radius' : radius,
        'latitude': _lat,
        'longitude': _lon
      });

      if(resp.data is Map)
      {
        if(resp.data['Code'] == 100)
        {
          List apiResults = resp.data['Results'];
          for(int i = 0; i < apiResults.length; i++)
          {
            Marker tmpMarker = Marker(
              markerId: MarkerId(i.toString()),
              position: LatLng(apiResults[i]['lat'], apiResults[i]['lon']),
              infoWindow: InfoWindow(
                title: apiResults[i]['name'] != null ? apiResults[i]['name'] : 'Unamed'
              )
            );
            
            _results.add(tmpMarker);
          }

          return _results;
        }else{
          // return empty response
          return Set();
        }
      }

      return Set();
    }on CloudFunctionsException catch (e) {
      print('CloudFunctionsException');
      print(e);
      return Set();
    }catch(e){
      print('Generic exception');
      print(e.toString());
      return Set();
    }
  }
}
