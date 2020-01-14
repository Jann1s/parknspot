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

  Future<Set<Marker>> getParkingLocations(int radius, double lat, double lon) async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'getParkingLocations'
    );
    try {
      HttpsCallableResult resp = await callable.call(<String,dynamic>{
        'radius' : radius,
        'lat': position.latitude,
        'lon': position.longitude
      });

      if(resp.data['Code'] == 100){
        //return true;
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
