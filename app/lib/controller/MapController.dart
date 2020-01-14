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

  Future<List<Marker>> getParkingLocations(int radius) async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getParkingLocations'
    );
    try {
      HttpsCallableResult resp = await callable.call(<String,dynamic>{
        'radius' : radius,
        'latitude': position.latitude,
        'longitude': position.longitude
      });

      if(resp.data['Code'] == 100){
        //print(resp.data['Places']);
    
        return resp.data['Places']['results'].map<Marker>((result) => new Marker(
          markerId: MarkerId(result['id'].toString()),
          position: LatLng(result['geometry']['location']['lat'], result['geometry']['location']['lng']),
          infoWindow: InfoWindow(
              title:
                  result['name']),
        )).toList();
        
        //return resp.data['Places']['results'].map<String>((result) => result['name'].toString()).toList();
      }else{
        print('code != 100');
        //return false;
      }
    }on CloudFunctionsException catch (e) {
      print('CloudFunctionsException');
      print(e);
      //return false;
    }catch(e){
      print('Generic exception');
      print(e);
      //return false;
    }
  }
}
